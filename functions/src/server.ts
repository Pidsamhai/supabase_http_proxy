import * as express from "express";
import * as cors from "cors";
import * as dotenv from "dotenv";

dotenv.config();
const server = express();
server.use(cors());

export default function (route: express.Router) {
  server.use(route);
  return server;
}
