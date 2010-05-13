
gloader.load(
    ["glow", "1.1.0", "glow.dom","glow.dragdrop", "glow.forms", "glow.widgets", "glow.widgets.Sortable", "glow.widgets.Overlay"],
    {
        async: true,
        onLoad: function(glow) {


        /* design tab - sort topic order */
        new glow.widgets.Sortable(
            '.dna-list-topic-col1,.dna-list-topic-col2'
        );

        new glow.widgets.Sortable(
         '.dna-list-topic-col'
        );

    }
});
