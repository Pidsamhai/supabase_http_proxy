import * as express from "express";
import * as cors from "cors";
import rateLimit from "express-rate-limit";
import * as dotenv from "dotenv";
import ApiRoute from "./route/api";
import UserRoute from "./route/user";
import TemplateRoute from "./route/template";
import * as path from "path";
import Notfound from "./route/not-found";

dotenv.config();

const port = process.env.PORT || 9000;
const server = express();

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: { message: "Too many requests, please try again later." },
});

server.use(cors());

// Handler rate limit and not found in api route
server.use("/api/v1/*", [limiter, Notfound]);

server.use("/api/v1", [ApiRoute, TemplateRoute, UserRoute]);

// Handler web app static file
server.use(express.static(path.resolve(__dirname, "..", "public")));

// Handler not found when direct access from url
server.get("*", function (_req, res) {
  res.sendFile(path.resolve(__dirname, "..", "public/index.html"));
});

server.listen(port, () => {
  console.log("\x1b[36m", `Live on http://127.0.0.1:${port}`);
});
