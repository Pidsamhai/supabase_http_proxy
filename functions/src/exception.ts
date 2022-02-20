/** Class representing Error when can not find Template from database */
export class TemplateNotFound extends Error {
  /**
 * Add two numbers.
 * @param {string} id The id of template.
 */
  constructor(id: string) {
    super();
    this.message = `Template ${id} not found`;
  }
}
