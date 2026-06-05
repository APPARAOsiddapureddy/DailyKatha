package com.dailykatha.daily_katha

import android.content.Intent
import android.util.Base64
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.truecaller.android.sdk.oAuth.TcOAuthCallback
import com.truecaller.android.sdk.oAuth.TcOAuthData
import com.truecaller.android.sdk.oAuth.TcOAuthError
import com.truecaller.android.sdk.oAuth.TcSdk
import com.truecaller.android.sdk.oAuth.TcSdkOptions
import java.security.MessageDigest
import java.security.SecureRandom
import kotlin.concurrent.thread

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "dailykatha/truecaller"
    private var channelResult: MethodChannel.Result? = null
    private var sdkInitialized = false
    private lateinit var authorizationLauncher: ActivityResultLauncher<Intent>

    private var pendingState: String = ""
    private var pendingCodeVerifier: String = ""

    private val truecallerCallback = object : TcOAuthCallback {
        override fun onSuccess(tcOAuthData: TcOAuthData) {
            Log.i("Truecaller", "onSuccess callback: state='${tcOAuthData.state}', authorizationCode length=${tcOAuthData.authorizationCode?.length ?: 0}")
            val result = channelResult ?: return
            val returnedState = tcOAuthData.state.trim()
            if (pendingState.isNotEmpty() && returnedState.isNotEmpty() && pendingState != returnedState) {
                runOnUiThread {
                    deliverError(
                        result,
                        "STATE_MISMATCH",
                        "Truecaller returned an unexpected state value",
                    )
                }
                return
            }

            val authorizationCode = tcOAuthData.authorizationCode.trim()
            Log.d("Truecaller", "authorizationCode (trimmed) length=${authorizationCode.length}")
            if (authorizationCode.isBlank()) {
                runOnUiThread {
                    Log.w("Truecaller", "Missing authorization code in TcOAuthData")
                    deliverError(
                        result,
                        "MISSING_AUTH_CODE",
                        "Truecaller did not return an authorization code",
                    )
                }
                return
            }

            val scopesGranted = tcOAuthData.scopesGranted.map { it.toString() }

            runOnUiThread {
                result.success(
                    mapOf(
                        "authorizationCode" to authorizationCode,
                        "state" to returnedState,
                        "codeVerifier" to pendingCodeVerifier,
                        "scopesGranted" to scopesGranted,
                    ),
                )
                clearPending()
            }
        }

        override fun onFailure(tcOAuthError: TcOAuthError) {
            Log.w("Truecaller", "onFailure callback: code=${tcOAuthError.errorCode}, message=${tcOAuthError.errorMessage}")
            val result = channelResult ?: return
            runOnUiThread {
                deliverError(
                    result,
                    "TRUECALLER_${tcOAuthError.errorCode}",
                    tcOAuthError.errorMessage.ifBlank { "Truecaller verification failed" },
                )
            }
        }

        override fun onVerificationRequired(tcOAuthError: TcOAuthError?) {
            Log.w("Truecaller", "onVerificationRequired callback: code=${tcOAuthError?.errorCode}, message=${tcOAuthError?.errorMessage}")
            val result = channelResult ?: return
            val code = tcOAuthError?.errorCode ?: -1
            val message = tcOAuthError?.errorMessage?.ifBlank { null } ?: "Truecaller verification needs another step"
            runOnUiThread {
                deliverError(
                    result,
                    "TRUECALLER_VERIFICATION_REQUIRED_$code",
                    message,
                )
            }
        }
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        authorizationLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            try {
                TcSdk.getInstance().onActivityResultObtained(this, result.resultCode, result.data)
            } catch (t: Throwable) {
                channelResult?.let {
                    deliverError(
                        it,
                        "TRUECALLER_ACTIVITY_RESULT",
                        t.message ?: "Truecaller activity result could not be processed",
                    )
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLogin" -> startTruecallerLogin(result)
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        try {
            TcSdk.clear()
        } catch (_: Throwable) {
        }
        sdkInitialized = false
        super.onDestroy()
    }

    private fun startTruecallerLogin(result: MethodChannel.Result) {
        if (channelResult != null) {
            result.error("IN_PROGRESS", "Truecaller verification is already running", null)
            return
        }
        channelResult = result
        pendingState = generateState()
        pendingCodeVerifier = generateCodeVerifier()
        val codeChallenge = deriveCodeChallenge(pendingCodeVerifier)
        if (codeChallenge.isBlank()) {
            deliverError(result, "PKCE_FAILURE", "Could not create a Truecaller code challenge")
            return
        }

        thread(name = "truecaller-init") {
            try {
                if (!sdkInitialized) {
                    val options = TcSdkOptions.Builder(this@MainActivity, truecallerCallback)
                        .consentHeadingOption(TcSdkOptions.SDK_CONSENT_HEADING_CONTINUE_WITH)
                        .sdkOptions(TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS)
                        .build()
                    TcSdk.init(options)
                    sdkInitialized = true
                }

                val usable = TcSdk.getInstance().isOAuthFlowUsable
                if (!usable) {
                    runOnUiThread {
                        deliverError(
                            result,
                            "TRUECALLER_NOT_USABLE",
                            "Truecaller app is not installed or not signed in on this device",
                        )
                    }
                    return@thread
                }

                TcSdk.getInstance().setOAuthState(pendingState)
                TcSdk.getInstance().setOAuthScopes(arrayOf("openid", "phone", "profile"))
                TcSdk.getInstance().setCodeChallenge(codeChallenge)

                runOnUiThread {
                    try {
                        TcSdk.getInstance().getAuthorizationCode(this@MainActivity, authorizationLauncher)
                    } catch (t: Throwable) {
                        deliverError(
                            result,
                            "TRUECALLER_START_FAILED",
                            t.message ?: "Could not open Truecaller verification",
                        )
                    }
                }
            } catch (t: Throwable) {
                runOnUiThread {
                    deliverError(
                        result,
                        "TRUECALLER_INIT_FAILED",
                        t.message ?: "Could not initialize Truecaller",
                    )
                }
            }
        }
    }

    private fun deliverError(result: MethodChannel.Result, code: String, message: String) {
        Log.w("Truecaller", "deliverError -> code=$code message=$message")
        result.error(code, message, null)
        clearPending()
    }

    private fun clearPending() {
        channelResult = null
        pendingState = ""
        pendingCodeVerifier = ""
    }

    private fun generateState(): String = randomUrlSafeToken(24)

    private fun generateCodeVerifier(): String = randomUrlSafeToken(64)

    private fun randomUrlSafeToken(byteCount: Int): String {
        val bytes = ByteArray(byteCount)
        SecureRandom().nextBytes(bytes)
        return Base64.encodeToString(bytes, Base64.NO_WRAP or Base64.NO_PADDING or Base64.URL_SAFE)
    }

    private fun deriveCodeChallenge(codeVerifier: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(codeVerifier.toByteArray(Charsets.US_ASCII))
        return Base64.encodeToString(digest, Base64.NO_WRAP or Base64.NO_PADDING or Base64.URL_SAFE)
    }
}
