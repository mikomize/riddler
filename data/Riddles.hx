package data;

import yawf.redis.RedisHashKey;

typedef RiddlesTypedef = RedisHashKey<Riddle>;

class Riddles extends RiddlesTypedef {
	public function new () {
		super("riddles");
	}
}