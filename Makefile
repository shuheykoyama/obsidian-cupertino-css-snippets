# Load user-specific vault path from config.mk (optional, won't error if missing)
-include config.mk

REPO_SNIPPETS := snippets
CSS_FILES     := cupertino-transparency.css thino-sidebar-fix.css

.PHONY: sync deploy diff install-hooks

# iCloud → repo (also runs automatically via pre-commit hook)
sync:
	@for f in $(CSS_FILES); do \
		cp "$(VAULT_SNIPPETS)/$$f" "$(REPO_SNIPPETS)/$$f"; \
	done
	@echo "Synced: vault → repo"

# repo → iCloud
deploy:
	@for f in $(CSS_FILES); do \
		cp "$(REPO_SNIPPETS)/$$f" "$(VAULT_SNIPPETS)/$$f"; \
	done
	@echo "Deployed: repo → vault"

# Show diff between repo and vault
diff:
	@for f in $(CSS_FILES); do \
		diff -u "$(REPO_SNIPPETS)/$$f" "$(VAULT_SNIPPETS)/$$f" || true; \
	done

# Install git hooks
install-hooks:
	@echo '#!/bin/sh' > .git/hooks/pre-commit
	@echo 'make sync && git add snippets/' >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Installed pre-commit hook"
