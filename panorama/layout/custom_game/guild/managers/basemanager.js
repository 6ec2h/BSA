/**
 * @typedef {Object} BaseManagerConstructor
 * @property {Guild} [guild]
 */

class BaseManager extends UpdateManager {
	/**
	 * @type {Guild}
	 */
	guild

	/**
	 * @type {Collection}
	 */
	cache

	/**
	 * @param {BaseManagerConstructor} args
	 */
	constructor(args) {
		super()

		if (args.guild)
			Object.defineProperty(this, "guild", {
				enumerable: false,
				writable: true,
				value: args.guild,
			})
	}

	populate() { }
}
