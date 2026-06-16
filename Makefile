.PHONY: evals

evals:
	python3 opencode/.config/opencode/evals/run_evals.py --suite offline --workspace .
