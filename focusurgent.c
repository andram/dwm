void focusurgent(const Arg *arg);

void
focusurgent(const Arg *arg) {
	Client *c;
	Monitor *m;

	for(m = mons; m; m = m->next) {
		for(c = m->clients; c; c = c->next) {
			if(c->isurgent) {
				selmon = m;
				if(!ISVISIBLE(c)) {
					selmon->seltags ^= 1;
					selmon->tagset[selmon->seltags] = c->tags;
				}
				focus(c);
				arrange(selmon);
				return;
			}
		}
	}
}
