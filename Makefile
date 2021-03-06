default:
	@echo 'Nothing to do. Simply do a `make install` and it will put the symlink in ~/.vim/plugin/revim.vim, plus attempt to add ~/bin/reval.'
	@echo '(Also, if you want to default to Ruby, consider: make ruby)'
	@echo '   (...and, there is also make linewise, if you really truly want it.)'

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

ruby:
	echo "let g:revallang = 'ruby'" >> ~/.reval.vimrc

# I don't really recommend this, but it's here in case you want it.
linewise:
	echo "let g:revallinewise = 1" >> ~/.reval.vimrc

uninstall:
	-rm ~/.vim/plugin/reval.vim
	-rm ~/bin/reval
