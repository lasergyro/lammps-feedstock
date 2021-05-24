#!/bin/bash

# setup test script, run and get output
# count lines that go WARNING: Communication cutoff
# check there's few

set -eu

function run_lammps () {
	lmp -log none -nocite <<-EOF
	units		lj
	atom_style	angle

	lattice		fcc 0.8442
	region		box block 0 10 0 10 0 10
	create_box	1 box bond/types 1 extra/bond/per/atom 1
	create_atoms 1 box
	mass		1 1.0

	velocity	all create 3.0 87287 loop geom

	pair_style	lj/cut 2.5
	pair_coeff	1 1 1.0 1.0 2.5


	create_bonds single/bond 1 1 2

	bond_style harmonic
	bond_coeff 1 5.0 4.0

	neighbor	0.3 bin
	neigh_modify every 1 delay 1

	comm_modify cutoff 3

	fix		1 all nph x 0 0 10 dilate all

	thermo		1
	run		100
	EOF
}

run_lammps > out.lmp


nlines=$( cat out.lmp | grep -c "WARNING: Communication cutoff" | wc -l )
echo $nlines

if [ ! $nlines = 1 ]; then
	exit 1
fi