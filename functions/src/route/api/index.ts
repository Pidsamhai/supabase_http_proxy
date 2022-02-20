import * as express from "express";
const route = express.Router();

route.get("/", (_, res) => {
  res.json({
    message: "Server Alive",
    date: Date.now(),
  });
});

export default route;
