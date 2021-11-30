---
name: dcw release checklist
about: Checklist for a new dcw release.
title: 'Release dcw x.x.x'
labels: ''
assignees: ''

---

**Version**:  x.x.x

**Scheduled date**: XXX XX, 20XX

**Before release**:

- [ ] Check the [changelog](https://github.com/GenericMappingTools/dcw-gmt/blob/master/ChangeLog).
- [ ] Check the settings in [config.mk](https://github.com/GenericMappingTools/dcw-gmt/blob/master/config.mk).
  - [ ] `GMT_VERSION` sets the correct minimum required GMT version.
  - [ ] `DCW_VERSION` sets the correct version of DCW to be released.
  - [ ] `DCW_DATE` sets the correct release date.
- [ ] Run `make spotless` to clear out any old distribution files.
- [ ] Run `make all` to make the dcw-gmt.nc file, create the tarball and zipfile, compute the MD5 checksum of the tarball, and create the dcw figure.
- [ ] Run `place-gmt` to place the tarball on the gmt ftp (@meghanrjones or @pwessel).
- [ ] Run `place-dcw` to place the zip file on the dcw ftp and website (@pwessel).
- [ ] Create a new [GitHub release](https://github.com/GenericMappingTools/dcw-gmt/releases).
  - [ ] Upload the tarbell.
  - [ ] Add a description to the release.
  - [ ] Add the MD5 checksum to the release notes.
- [ ] Run `update-dataserver` to update the files on the GMT server using the GitHub release (@pwessel or @meghanrjones).
