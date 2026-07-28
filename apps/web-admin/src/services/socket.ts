// Real-time WebSocket Service Client for Web Admin Dashboard

export class WebAdminSocket {
  private static socket: WebSocket | null = null;
  private static listeners: Map<string, Array<(data: any) => void>> = new Map();

  static connect(companyId: string = 'demo-company-id') {
    if (this.socket) return;

    try {
      // Connect to Socket.IO / WebSocket server
      const wsUrl = `ws://localhost:4000/socket.io/?EIO=4&transport=websocket`;
      this.socket = new WebSocket(wsUrl);

      this.socket.onopen = () => {
        console.log('⚡ Connected to NestJS WebSockets Gateway');
      };

      this.socket.onmessage = (event) => {
        try {
          // Parse WebSocket message payload
          if (typeof event.data === 'string' && event.data.startsWith('42')) {
            const jsonStr = event.data.substring(2);
            const [eventName, payload] = JSON.parse(jsonStr);
            this.emitLocal(eventName, payload);
          }
        } catch (_) {
          // Ignore heartbeats
        }
      };

      this.socket.onclose = () => {
        this.socket = null;
      };
    } catch (e) {
      console.warn('WebSocket connection not available:', e);
    }
  }

  static on(event: string, callback: (data: any) => void) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event)!.push(callback);
  }

  private static emitLocal(event: string, payload: any) {
    if (this.listeners.has(event)) {
      this.listeners.get(event)!.forEach((cb) => cb(payload));
    }
  }
}
