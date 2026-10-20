# WarehousePG pgSphere

## Introduction

pgSphere is an extension for spherical geometry, mainly used in astronomy. It
adds data types for spherical points, circles, lines, ellipses, polygons, paths
and coordinate ranges to a distributed database like WarehousePG, together with
operators for membership, overlap and distance, functions for area and
circumference, rotation by Euler angles, and GiST and BRIN indexing of spherical
data.

This repository is a fork of the open-source pgSphere project
(github.com/postgrespro/pgsphere), renamed to whpg-pgsphere and maintained for
WarehousePG. The `whpg` branch is based on pgSphere 1.5.2, with the WarehousePG
changes on top.

## Building and Testing

WarehousePG packages are built without HEALPix/MOC support. With the
WarehousePG `pg_config` on your `PATH`:

```
make USE_HEALPIX=0
make USE_HEALPIX=0 install         # may need root to write into $GPHOME
# needs a running WarehousePG cluster; the regression output assumes the
# Postgres planner, so turn GPORCA off as the packaging smoke test does
PGOPTIONS='-c optimizer=off' make USE_HEALPIX=0 installcheck
```

Then load the extension with `CREATE EXTENSION pg_sphere;`.

## Documentation

* Upstream readme, including upgrade instructions:
  [README.pg_sphere](README.pg_sphere)
* pgSphere documentation: https://postgrespro.github.io/pgsphere/

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and the
[Code of Conduct](CODE-OF-CONDUCT.md). To report a security issue, see
[SECURITY.md](SECURITY.md).

## License

BSD 3-Clause. See [LICENSE.md](LICENSE.md).

## Credits

pgSphere is developed by the pgSphere development team; see
[COPYRIGHT.pg_sphere](COPYRIGHT.pg_sphere) and
https://github.com/postgrespro/pgsphere.
