## Package Maintenance Workflow

Follow these steps to update and test a package:

### Update Package
```bash
cd <package>
uscan --verbose --download-current-version     # Download new upstream version
dch -v <version>-gsd1 "New upstream version"   # Create changelog
dch -r stable                           # Mark release
dpkg-source -b .                        # Build source package
```

### Test Build
```bash
cd ..
dpkg-source -x <package>_<version>-gsd1.dsc   # Extract sources
cd <package>_<version>
debuild -us -uc                         # Build binary package
```
