import * as express from "express";
// import * as path from "path";
import deleteUserController from "../controller/delete-user.controller";
import notFoundController from "../controller/not-found.controller";
import templateController from "../controller/template.controller";
import web404Controller from "../controller/web-404.controller";

const route = express.Router();

const templateRoute = express.Router().all("/:template/*", templateController);
const deleteUserRoute = express
  .Router()
  .delete("/:userId", deleteUserController);

route.use("/api/v1/template", templateRoute);
route.use("/api/v1/user", deleteUserRoute);
route.use("/api/*", notFoundController);

// Handler web app static file
route.use(express.static(path.resolve(__dirname, "..", "..", "public")));

// Handler not found when direct access from url
route.get("*", web404Controller);

export default route;
