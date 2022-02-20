import { rest } from "msw";
import { setupServer } from "msw/node";
import { TemplateNotFound } from "../exception";
import { supabaseService } from "../services/supabase.service";
import { Template } from "../types/template";

const mockServer = setupServer(
  rest.get("*", (req, res, ctx) => {
    if (req.url.searchParams.get("uid") == "eq.123") {
      return res(
        ctx.json({
          name: "{JSON} Placeholder",
          baseUrl: "https://jsonplaceholder.typicode.com/",
          descriptions: "Free fake API for testing and prototyping.",
          headers: {},
          params: {},
        })
      );
    }
    if (req.url.searchParams.get("uid") == "eq.1150") {
      return res(ctx.status(500));
    }
    return res(
      ctx.status(404),
      ctx.json({
        message: "JSON object requested, multiple (or no) rows returned",
        details:
          "Results contain 0 rows, application/vnd.pgrst.object+json requires 1 row",
      })
    );
  })
);

beforeAll(() => {
  mockServer.listen();
});
afterAll(() => {
  mockServer.close();
});

test("get exist template should be return template", async () => {
  const exspecData: Template = {
    name: "{JSON} Placeholder",
    baseUrl: "https://jsonplaceholder.typicode.com/",
    descriptions: "Free fake API for testing and prototyping.",
    headers: {},
    params: {},
  };
  const template = await supabaseService.getTemplate("123");
  expect(template).toStrictEqual(exspecData);
});

test("get not exist template should be error TemplateNotFound", () => {
  expect(supabaseService.getTemplate("111")).rejects.toThrow(TemplateNotFound);
});

test("test server error TemplateNotFound", () => {
  expect(supabaseService.getTemplate("1150")).rejects.toThrow(TemplateNotFound);
});
