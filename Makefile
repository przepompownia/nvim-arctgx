.PHONY: install-vscode-php-debug install-vscode-bash-debug install-vscode-cpptools-debug luarc

SHELL := /bin/bash
DIR := ${CURDIR}

vscodePhpDebugVersion := '1.33.1'
vscodePhpDebugUrl := 'https://github.com/xdebug/vscode-php-debug/releases/download/v1.33.1/php-debug-1.33.1.vsix'
bashDebugVersion := '0.3.9'
bashDebugUrl := 'https://github.com/rogalmic/vscode-bash-debug/releases/download/untagged-438733f35feb8659d939/bash-debug-0.3.9.vsix'
cpptoolsVersion := '1.16.3'
cpptoolsUrl := 'https://github.com/microsoft/vscode-cpptools/releases/download/v1.16.3/cpptools-linux.vsix'

install-vscode-php-debug:
	$(DIR)/bin/dap-adapter-utils install xdebug vscode-php-debug $(vscodePhpDebugVersion) $(vscodePhpDebugUrl)
	$(DIR)/bin/dap-adapter-utils setAsCurrent vscode-php-debug $(vscodePhpDebugVersion)

install-vscode-bash-debug:
	$(DIR)/bin/dap-adapter-utils install rogalmic vscode-bash-debug $(bashDebugVersion) $(bashDebugUrl)
	$(DIR)/bin/dap-adapter-utils setAsCurrent vscode-bash-debug $(bashDebugVersion)

install-vscode-cpptools-debug:
	$(DIR)/bin/dap-adapter-utils install microsoft vscode-cpptools $(cpptoolsVersion) $(cpptoolsUrl)
	$(DIR)/bin/dap-adapter-utils setAsCurrent vscode-cpptools $(cpptoolsVersion)

require-init:
ifndef nvimInit
	$(error nvimInit path is required)
else
	@echo > /dev/null
endif

projectDir := $(DIR)
.ONESHELL:
luarc: require-init
	cd $(projectDir)
	nvim -u $(nvimInit) -l $(DIR)/lua/arctgx/luaLs/generateLuarcJson.lua

start: install-vscode-php-debug
