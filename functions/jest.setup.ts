jest.spyOn(console, "log").mockImplementation(() => {});
jest.spyOn(console, "debug").mockImplementation(() => {});
jest.spyOn(console, "info").mockImplementation(() => {});
jest.spyOn(console, "table").mockImplementation(() => {});
jest.spyOn(console, "warn").mockImplementation(() => {});
jest.spyOn(console, "error").mockImplementation(() => {});
