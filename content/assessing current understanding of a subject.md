---
created: 2026-01-24
publish: true
---

## Bayesian Knowledge Tracing (BKT)

- Used to estimate whether student has mastered a skill.
- Maintains 4 probablities
	- P(L): prior probability that you know the skill before practice
	- P(T): probability you'll learn the skill after each opportunity
	- P(G): Probability of guessing without actually knowing
	- P(S): Probability of "slipping", or answering wrong despite knowing
- Strengths:
	- Works on small data sets
	- models learning process over time
- Weaknesses:
	- assumes binary state of knowledge (either you know or you don't), which doesn't necessarily reflect how learning works irl
- Compare BKT to:
	- simple thresholds (multiple choice test for example): how many did student get right?
	- Item Response Theory: estimates ability and difficulty of item at the same time. Good for point estimates. Doesn't track student learning over time.
	- Deep Knowledge Tracing: uses neural nets. more powerful than BKT but black box on _why_ it thinks you've mastered something.
	- 

## Tools
- [[OATutor]] - open source tool for learning that includes BKT