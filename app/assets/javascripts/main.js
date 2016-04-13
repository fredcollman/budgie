$(function() {
	$('.new-tag-btn').click(function() {
		$(this).closest('tr').find('form').removeClass('hide');
		$(this).addClass('hide');
	});

	$('.cancel-tag-btn').click(function() {
		$(this).closest('form').addClass('hide');
		$(this).closest('tr').find('.new-tag-btn').removeClass('hide');
	});
});
