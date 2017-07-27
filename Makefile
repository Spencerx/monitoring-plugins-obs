test:
	@perl -It -c ./check_obs_events
	@prove -It t/*.t
