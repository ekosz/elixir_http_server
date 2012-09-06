EBIN_DIR=ebin

compile: ebin

ebin: lib/*.ex
	@ rm -f ebin/::*.beam
	@ echo Compiling ...
	@ mkdir -p $(EBIN_DIR)
	@ touch $(EBIN_DIR)
	elixirc lib/**/*.ex -o $(EBIN_DIR)
	@ echo

test: compile
	@ echo Running tests ...
	time elixir -pa ebin -r "test/**/*_test.exs"
	@ echo

clean:
	rm -rf $(EBIN_DIR)
	@ echo

start: compile
	@ echo Starting server
	elixir -pa ebin -e "Kappa.Server.listen(5000)"
	@ echo
