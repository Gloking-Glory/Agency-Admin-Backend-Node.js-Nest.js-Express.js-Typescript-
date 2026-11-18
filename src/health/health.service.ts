import { Injectable } from '@nestjs/common';
import type { HealthResponse } from './types/types.js';

@Injectable()
export class HealthService {
  getHealth(): HealthResponse {
    return {
        "status": 'ok',
        "message": 'Agency Admin API is running'
    }
  }
}
