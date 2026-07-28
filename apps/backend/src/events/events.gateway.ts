import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(EventsGateway.name);

  handleConnection(client: Socket) {
    this.logger.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('joinCompanyRoom')
  handleJoinRoom(client: Socket, companyId: string) {
    const room = `company_${companyId}`;
    client.join(room);
    this.logger.log(`Client ${client.id} joined room: ${room}`);
    return { event: 'joinedRoom', room };
  }

  // Helper method to emit events to a specific company room
  emitToCompany(companyId: string, event: string, payload: any) {
    const room = `company_${companyId}`;
    this.server.to(room).emit(event, payload);
    this.logger.log(`Emitted [${event}] to room [${room}]`);
  }

  // Helper method to broadcast events globally to all connected clients
  broadcastEvent(event: string, payload: any) {
    this.server.emit(event, payload);
    this.logger.log(`Broadcasted [${event}] globally`);
  }
}
