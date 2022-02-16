import * as express from "express";
import * as cors from "cors";
import rateLimit from "express-rate-limit";
import * as dotenv from "dotenv";
import ApiRoute from "./route/api";
import UserRoute from "./route/user";
import TemplateRoute from "./route/template";
import * as path from "path";

dotenv.config();

const port = process.env.PORT || 9000;
const server = express();

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: { message: "Too many requests, please try again later." },
});

server.use(cors());
server.use("/api/v1/*", limiter);
server.use("/api/v1", [ApiRoute, TemplateRoute, UserRoute]);
server.use(express.static(path.resolve(__dirname, "..", "public")));

// Handle not found
server.get("*", function (_req, res) {
  res.sendFile(path.resolve(__dirname, "..", "public/index.html"));
});

server.listen(port, () => {
  console.log("\x1b[36m", `Live on http://127.0.0.1:${port}`);
});
