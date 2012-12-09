build:
	@rm -rf html
	@make prod
	@make test

prod: 
	@echo "Making our product and tests folders if they don't already exist"
	@mkdir -p product tests
	@echo "Clearing out previous folder..."
	@rm -rf product/*
	@echo "Copying Kickstrap folder..."
	@mkdir product/Kickstrap
	@cp -r assets/Kickstrap/* product/Kickstrap/
	@echo "Adding sample uninstalled app"
	@cp assets/misc/qunit.zip product/Kickstrap/
	@echo "Delete contents of apps folder and individually select apps..."
	@rm -rf product/Kickstrap/apps/*
		@echo "-Animate.CSS"
		@cp -r assets/Kickstrap/apps/animatecss product/Kickstrap/apps/
		
		@echo "-Bootstrap"
		@cp -r assets/Kickstrap/apps/bootstrap product/Kickstrap/apps/
	
		@echo "-Knockout.js"
		@cp -r assets/Kickstrap/apps/knockout product/Kickstrap/apps/
	
		@echo "-Chosen"
		@cp -r assets/Kickstrap/apps/chosen product/Kickstrap/apps/
	
		@echo "-Color Schemer"
		@cp -r assets/Kickstrap/apps/colorschemer product/Kickstrap/apps/
	
		@echo "-Pines Notify"
		@cp -r assets/Kickstrap/apps/pinesnotify product/Kickstrap/apps/
	
		@echo "-jQuery Lint"
		@cp -r assets/Kickstrap/apps/jquerylint product/Kickstrap/apps/
	
		@echo "-Updater"
		@cp -r assets/Kickstrap/apps/updater product/Kickstrap/apps/
		
		@echo "-Firebug Lite"
		@cp -r assets/Kickstrap/apps/firebuglite product/Kickstrap/apps/
	
		@echo "-Universal"
		@cp -r assets/Kickstrap/apps/universal product/Kickstrap/apps/
	
	@echo "Removing some themes not ready for prime time..."
	@find . -name .DS_Store -exec rm -f {} \;
	@rm -r product/Kickstrap/themes/smallworld/*
	@rmdir product/Kickstrap/themes/smallworld
	@rm -r product/Kickstrap/themes/smallworld.less
	@rm -rf product/Kickstrap/themes/confetti/*
	@rmdir product/Kickstrap/themes/confetti
	@rm -r product/Kickstrap/themes/confetti.less
	@echo "Removing .git directory from Bootstrap"
	@rm -rf product/Kickstrap/bootstrap/.git product/Kickstrap/bootstrap/.[a-z]*
	@rm -rf tests/Kickstrap/bootstrap/.git tests/Kickstrap/bootstrap/.[a-z]*
	@echo "Spring cleaning"
	@rm product/Kickstrap/js/sample.js
	@rm -r product/Kickstrap/apps/universal/ks-window
	@node build.js production
	@rm product/lab.html

	@uglifyjs product/Kickstrap/js/kickstrap.js -mc > product/Kickstrap/js/kickstrap.min.js 
	@echo "Build complete."

test: 
	@echo "Clearing out previous folder..."
	@find . -name .DS_Store -exec rm -f {} \;
	@rm -rf tests/*
	@echo "Copying Kickstrap folder..."
	@mkdir tests/Kickstrap
	@cp -r assets/Kickstrap/* tests/Kickstrap/
	@cp -r assets/tests/* tests/
	@node build.js test
	@echo "Build complete."
