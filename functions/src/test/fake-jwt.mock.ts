import * as njwt from "njwt";

const JWT_SECRET = "setcret code";

const payload = {
  aud: "authenticated",
  sub: "a466d183-488a-461b-90be-f64be77ed54d",
  email: "usertest@test.com",
  phone: "",
  app_metadata: {
    provider: "email",
    providers: ["email"],
  },
  user_metadata: {},
  role: "authenticated",
};

const ALIVE_JWT_TOKEN = njwt
  .create(payload, JWT_SECRET)
  .setExpiration(new Date(`${new Date().getFullYear() + 1}-01-01`))
  .compact();

const EXPIRED_JWT_TOKEN = njwt
  .create(payload, JWT_SECRET)
  .setExpiration(new Date(`${new Date().getFullYear() - 1}-01-01`))
  .compact();

export { ALIVE_JWT_TOKEN, JWT_SECRET, EXPIRED_JWT_TOKEN };
