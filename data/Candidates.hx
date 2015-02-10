package data;

import yawf.redis.RedisHashKey;

typedef CandidatesTypedef = RedisHashKey<Candidate>;

class Candidates extends CandidatesTypedef {
	public function new () {
		super("candidates");
	}
}