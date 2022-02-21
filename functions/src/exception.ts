/** Class representing Error when can not find Template from database */
class TemplateNotFound extends Error {
  /**
   * Add two numbers.
   * @param {string} id The id of template.
   */
  constructor(id: string) {
    super();
    this.message = `Template ${id} not found`;
  }
}

/** Class representing Error when can not find Template from database */
class UserNotFound extends Error {
  constructor() {
    super();
    this.message = "User not found";
  }
}

class TokenExpired extends Error {
  constructor() {
    super();
    this.message = "Token has been expired";
  }
}

export { TemplateNotFound, UserNotFound, TokenExpired };
