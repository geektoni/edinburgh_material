from matplotlib import rc
rc("font", family="serif", size=12)

import daft

pgm = daft.PGM([4,5], directed=False)
pgm.add_node(daft.Node("S1", r"$S_1$", 1, 3))
pgm.add_node(daft.Node("S2", r"$S_2$", 2, 4))
pgm.add_node(daft.Node("S3", r"$S_3$", 3, 3))
pgm.add_node(daft.Node("r1", r"$r^{(1)}$", 1, 1))
pgm.add_node(daft.Node("r2", r"$r^{(2)}$", 2, 1))
pgm.add_node(daft.Node("r3", r"$r^{(3)}$", 3, 1))
pgm.add_edge("S1", "r1")
pgm.add_edge("S2", "r1")
pgm.add_edge("S2", "r2")
pgm.add_edge("S3", "r2")
pgm.add_edge("S3", "r3")
pgm.add_edge("S1", "r3")
pgm.add_edge("S1", "S2")
pgm.add_edge("S1", "S3")
pgm.add_edge("S2", "S3")
pgm.render()

pgm.figure.savefig("q1c.png", dpi=150)
