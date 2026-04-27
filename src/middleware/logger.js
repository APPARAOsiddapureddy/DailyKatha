import morgan from 'morgan';

morgan.token('lang', (req) => req.lang || '-');
morgan.token('user-id', (req) => (req.user?.id ? String(req.user.id).slice(0, 8) : 'anon'));

export const httpLogger = morgan(':method :url :status :res[content-length] - :response-time ms | lang=:lang user=:user-id', {
  skip: (req) => req.url === '/health',
  stream: {
    write: (message) => console.log(message.trim()),
  },
});

