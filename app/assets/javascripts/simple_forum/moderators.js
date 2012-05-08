(function () {
    var search_users_timeout;

    var search_users = function (str) {
        var params = {'user_name_like':str};
        var $results = $('#search_users_result');
        $results.html('');
        $.getJSON(simple_forum.user_search_path, params, function (json) {
            $.each(json, function (key, val) {
                var $item = $('<li>' + val + ' <a href="#" class="add-moderator" data-user_id="' + key + '" data-user_name="' + val + '">[' + simple_forum.translations['add_moderator'] + ']</a></li>');
                $results.append($item);
            });
        });
    };

    $(function () {
        $('#search_users_input').keyup(function () {
            var $input = $(this);
            if (search_users_timeout) clearTimeout(search_users_timeout);
            search_users_timeout = setTimeout(function () {
                search_users($input.val());
            }, 300);
        });

        $('a.add-moderator').live('click', function () {
            var $this = $(this),
                user_id = $this.data('user_id'),
                user_name = $this.data('user_name');
            var html = simple_forum.moderator_template.replace(/temp_user_id/g, user_id).replace(/temp_user_name/g, user_name);
            $('#moderators').append(html);
            return false;
        });

        $('a.remove-moderator').live('click', function () {
            var $this = $(this);
            $this.closest('li').remove();
            return false;
        });
    });
})();