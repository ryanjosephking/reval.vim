default:
	@echo 'Nothing to do. Simply do a `make install` and it will put the symlink in ~/.vim/plugin/revim.vim, plus attempt to add ~/bin/reval.'

install:
	mkdir -p ~/.vim/plugin/
	ln -fs `pwd`/reval.vim ~/.vim/plugin/
	@if [ -d ~/bin/ ]; then \
		echo "# Found ~/bin/ dir, adding nifty 'reval' script there."; \
        ln -fs `pwd`/bin/reval ~/bin/; \
	else \
		echo "# Since you don't have a ~/bin/ dir, you can install bin/reval wherever you want, manually."; \
	fi
	@echo "# Installed. Invoke with \reval within vim, or else use the script."

uninstall:
	-rm ~/.vim/plugin/reval.vim
	-rm ~/bin/reval
