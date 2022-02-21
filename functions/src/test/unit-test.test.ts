/*eslint-disable */
import * as request from "supertest";
import server from "../server";
import route from "../route";
import { supabaseService } from "./../services/supabase.service";
import { TemplateNotFound, UserNotFound } from "../exception";
import { Template } from "../types/template";
import axios from "axios";
import { Request, Response } from "express";
import {
  ALIVE_JWT_TOKEN,
  JWT_SECRET,
  EXPIRED_JWT_TOKEN,
} from "./fake-jwt.mock";

beforeAll(() => {
  process.env.JWT_SECRET = JWT_SECRET;
});

afterEach(() => {
  jest.clearAllMocks();
});

test("GET /api/v1/ should be notfound (404)", (done) => {
  request(server(route))
    .get("/api/v1/")
    .expect("Content-Type", /json/)
    .expect("Content-Length", "23")
    .expect(404)
    .expect((res) => {
      expect(res.body).toStrictEqual({ message: "Not Found" });
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("GET /api/v1/template/1234 should error template not found (404)", (done) => {
  jest.spyOn(supabaseService, "getTemplate").mockImplementation((id) => {
    throw new TemplateNotFound(id);
  });
  request(server(route))
    .get("/api/v1/template/1234/todo/1")
    .expect("Content-Type", /json/)
    .expect(404)
    .expect((res) => {
      expect(res.body).toStrictEqual({ message: "Template 1234 not found" });
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("GET /api/v1/template/random/todo/1 should be success return data from api (200)", (done) => {
  const exspectData = { sample: "sample" };
  jest.spyOn(axios, "request").mockImplementation(() =>
    Promise.resolve({
      status: 200,
      headers: { "Content-type": "application/json" },
      data: exspectData,
    })
  );
  jest.spyOn(supabaseService, "getTemplate").mockImplementation(async (id) => {
    return <Template>{
      baseUrl: "",
      name: "",
      descriptions: "",
      headers: {},
      params: {},
    };
  });
  request(server(route))
    .get("/api/v1/template/random/todo/1")
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((res) => {
      expect(res.body).toStrictEqual(exspectData);
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("GET /api/v1/template/random/todo/1 should be not found api error (404)", (done) => {
  const exspectData = { message: "Api Error" };
  jest.spyOn(axios, "request").mockImplementation(() =>
    Promise.resolve({
      status: 404,
      headers: { "Content-type": "application/json" },
      data: exspectData,
    })
  );
  jest.spyOn(supabaseService, "getTemplate").mockImplementation(async (id) => {
    return <Template>{
      baseUrl: "",
      name: "",
      descriptions: "",
      headers: {},
      params: {},
    };
  });
  request(server(route))
    .get("/api/v1/template/random/todo/1")
    .expect("Content-Type", /json/)
    .expect(404)
    .expect((res) => {
      expect(res.body).toStrictEqual(exspectData);
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("GET /api/v1/template/random/todo/1 should be not found unknown error (404)", (done) => {
  jest.spyOn(axios, "request").mockImplementation(() => {
    throw Error("Random error");
  });
  jest.spyOn(supabaseService, "getTemplate").mockImplementation(async (id) => {
    return <Template>{
      baseUrl: "",
      name: "",
      descriptions: "",
      headers: {},
      params: {},
    };
  });
  request(server(route))
    .get("/api/v1/template/random/todo/1")
    .expect("Content-Type", /json/)
    .expect(404)
    .expect((res) => {
      expect(res.body).toStrictEqual({ message: "Not Found" });
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("DELETE /api/v1/user should error User not found (404)", (done) => {
  jest.spyOn(supabaseService, "deleteUser").mockImplementation((id) => {
    throw new UserNotFound();
  });
  request(server(route))
    .delete("/api/v1/user")
    .expect("Content-Type", /json/)
    .set("Authorization", "Bearer " + ALIVE_JWT_TOKEN)
    .expect(404)
    .expect((res) => {
      expect(res.body).toStrictEqual({ message: "User not found" });
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("DELETE /api/v1/user unknown error should be Delete error (410)", (done) => {
  jest.spyOn(supabaseService, "deleteUser").mockImplementation((id) => {
    throw new Error("Random error");
  });
  request(server(route))
    .delete("/api/v1/user")
    .expect("Content-Type", /json/)
    .set("Authorization", "Bearer " + ALIVE_JWT_TOKEN)
    .expect(410)
    .expect((res) => {
      expect(res.body).toStrictEqual({ message: "Delete error" });
    })
    .end(function (err, res) {
      if (err) return done(err);
      return done();
    });
});

test("DELETE /api/v1/user should be success (204)", (done) => {
  jest.spyOn(supabaseService, "deleteUser").mockImplementation(async (id) => {
    return;
  });
  request(server(route))
    .delete("/api/v1/user")
    .set("Authorization", "Bearer " + ALIVE_JWT_TOKEN)
    .expect(204)
    .end(function (err, _res) {
      if (err) return done(err);
      return done();
    });
});

test("DELETE /api/v1/user expired_token should throw TokenExpired (204)", (done) => {
  jest.spyOn(supabaseService, "deleteUser").mockImplementation(async (id) => {
    return;
  });
  request(server(route))
    .delete("/api/v1/user")
    .set("Authorization", "Bearer " + EXPIRED_JWT_TOKEN)
    .expect(401)
    .end(function (err, _res) {
      if (err) return done(err);
      return done();
    });
});

jest.mock("../controller/web-404.controller", () => {
  return {
    default: (_req: Request, res: Response) => {
      res.setHeader("Content-Type", "text/html");
      res.send("Test html 404 file");
    },
  };
});

test("GET /login should be send html page (200)", (done) => {
  request(server(route))
    .get("/login")
    .expect(200)
    .expect("Content-Type", /html/)
    .expect((res) => expect(res.text).toBe("Test html 404 file"))
    .end(function (err, _res) {
      if (err) return done(err);
      return done();
    });
});
