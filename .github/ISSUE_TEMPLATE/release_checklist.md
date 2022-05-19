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

**Release**

- [ ] Run `make place-gmt` to place the tarball on the gmt ftp (@meghanrjones or @pwessel).
- [ ] Run `make place-dcw` to place the zip file on the dcw ftp and website (@pwessel).
- [ ] Create a new [GitHub release](https://github.com/GenericMappingTools/dcw-gmt/releases).
  - [ ] Upload the tarball.
  - [ ] Add a description to the release.
  - [ ] Add the MD5 checksum and sha256sum to the release notes.
- [ ] Run `make update-dataserver` to update the files on the GMT server using the GitHub release (@pwessel or @meghanrjones).
- [ ] Update the dcw version in the [downloads](https://github.com/GenericMappingTools/website/blob/master/download/index.rst) section of the website.

**3rd-party update**

**More volunteers needed!** Please let us know if you volunteer to help to maintain dcw-gmt in these 3rd-party tools.

- Update [conda-forge feedstock](https://github.com/conda-forge/dcw-gmt-feedstock) (@seisman)
- Update [homebrew formula](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/gmt.rb) (@seisman)
- Update the builtin dcw-gmt version in the Windows installers (@joa-quim)
