.PHONY: deploy backup restore upgrade status cleanup help

help:
	@echo "All commands"
	@echo " make deploy - Istall docker and deploy gitlab"
	@echo " make backup - Create gitlab backup"
	@echo " make restore - Restore to lates backup"
	@echo " make upgrade - Upgrade gitlab to new version"
	@echo " make status - Show gitlab status"
	@echo " make cleanup - Remove unused docker images"

deploy:
	ansible-playbook -i inventory.ini playbook.yml -K

backup:
	ansible-playbook -i inventory.ini backup.yml -K

restore:
	ansible-playbook -i inventory.ini restore.yml -K

upgrade:
	ansible-playbook -i inventory.ini upgrade.yml -K

status:
	@./scripts/status.sh

cleanup:
	@./scripts/cleanup.sh
