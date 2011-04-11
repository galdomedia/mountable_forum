var post_preview = function() {
    $.ajax({
        type          : "GET",
        url           : post_preview_path,
        data          : $('#new_post_form').serializeArray(),
        success: function(data) {
            $('table.topic-table tr.preview').remove();
            $('table.topic-table').append(data);
        }
    });
    return false;
};

markItUpPostBodySettings = {
//	previewParserPath:	'', // path to your BBCode parser
    markupSet: [
        {name:'Bold', key:'B', openWith:'[b]', closeWith:'[/b]'},
        {name:'Italic', key:'I', openWith:'[i]', closeWith:'[/i]'},
        {name:'Underline', key:'U', openWith:'[u]', closeWith:'[/u]'},
        {separator:'---------------' },
        {name:'Picture', key:'P', replaceWith:'[img][![Url]!][/img]'},
        {name:'Link', key:'L', openWith:'[url=[![Url]!]]', closeWith:'[/url]', placeHolder:'Your text to link here...'},
        {separator:'---------------' },
        {name:'Size', key:'S', openWith:'[size=[![Text size]!]]', closeWith:'[/size]',
            dropMenu :[
                {name:'Big', openWith:'[size=50]', closeWith:'[/size]' },
                {name:'Normal', openWith:'[size=25]', closeWith:'[/size]' },
                {name:'Small', openWith:'[size=10]', closeWith:'[/size]' }
            ]},
        {separator:'---------------' },
        {name:'Bulleted list', openWith:'[list]\n', closeWith:'\n[/list]'},
//        {name:'Numeric list', openWith:'[list=[![Starting number]!]]\n', closeWith:'\n[/list]'},
        {name:'List item', openWith:'[*] '},
        {separator:'---------------' },
        {name:'Quotes', openWith:'[quote]', closeWith:'[/quote]'},
        {name:'Code', openWith:'[code]', closeWith:'[/code]'},
        {separator:'---------------' },
        {name:'Clean', className:"clean", replaceWith:function(markitup) {
            return markitup.selection.replace(/\[(.*?)\]/g, "")
        } },
        {name:'Preview', className:"preview", call:'post_preview' }
    ]
};

$(function() {
    $('textarea.markitup.post-body').markItUp(markItUpPostBodySettings);
});
