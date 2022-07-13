import { format as fnsFormat } from 'date-fns';

const FORMATS = {
  day: 'yyyy-MM-dd',
  hour: 'yyyy-MM-dd HH:00',
  minute: 'yyyy-MM-dd HH:mm'
};

export const format = (datetime: Date | string, period: string | null) => {
  if (typeof datetime === 'string') datetime = new Date(datetime);
  if (period) {
    return fnsFormat(datetime, FORMATS[period]);
  } else {
    return fnsFormat(datetime, 'yyyy-MM-dd HH:mm:ss');
  }
}
