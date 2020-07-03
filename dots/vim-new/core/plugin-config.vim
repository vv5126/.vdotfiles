" Plugin Configuration {
    for $bundle_group in g:evervim_bundle_groups
        " search all *.vim at same dir of bundle.
        call SourceConfigsIn($evervim_root . "/plugins/" . $bundle_group)
    endfor
" }
