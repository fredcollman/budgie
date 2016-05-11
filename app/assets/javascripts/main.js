$(function() {
	(function prepareTagForm() {
		function cancelTagForm(event) {
			event.preventDefault();
			$(this).closest('form').addClass('hide');
			$(this).closest('tr').find('.new-tag-btn').removeClass('hide');
		}

		function openTagForm(event) {
			event.preventDefault();
			$(this).closest('tr').find('form').removeClass('hide');
			$(this).addClass('hide');

			$('.cancel-tag-btn').click(cancelTagForm);
		}

		$(document).on('click', '.new-tag-btn', openTagForm);
	})();

	(function activateMaterializeSelect() {
		function activeSelect() {
			$('select').material_select();
		}

		$(document).ready(activeSelect);
		$(document).on('page:load', activeSelect);
	})();
});
