class Message extends BaseStructure {
	/**
	 * @param {MessageData} data
	 * @param {Guild} guild
	 * @param {MessagesManager} manager
	 */
	constructor(data, guild, manager) {
		super({ guild, manager })

		this.id = String(data.id)

		this.timestamp = parseDateTime(data.timestamp)
		this.authorId = String(data.author_sid64)

		if (this.authorId === "0" || !data.author_sid64) {
			this.isSystem = true
			this.authorId = String(SYSTEM_STEAM_ID)
		} else {
			this.isSystem = false
			this.authorId = String(data.author_sid64)
		}

		this.content = String(data.content)

		const date = new Date(this.timestamp)

		const hours = String(date.getHours()).padStart(2, "0")
		const minutes = String(date.getMinutes()).padStart(2, "0")

		this.shortTimestampString = `${hours}:${minutes}`
		this.fullTimestampString = formatFullDate(this.timestamp)
	}
}
