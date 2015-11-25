$(function(){
	var slideCount = $('#slider ul li').length;
	var slideWidth = $('#slider ul li').width();
	var slideHeight = $('#slider ul li').height();
	var sliderUlWidth = slideCount * slideWidth;

	$('#slider').css({ width: slideWidth, height: slideHeight });
	$('#slider ul').css({ width: sliderUlWidth, marginLeft: - slideWidth });
	$('#slider ul li:last-child').prependTo('#slider ul');

	function moveLeft() {
		$('#slider ul').animate({
			left: + slideWidth
		}, 200, function () {
			$('#slider ul li:last-child').prependTo('#slider ul');
			$('#slider ul').css('left', '');
		});
	};

	function moveRight() {
		$('#slider ul').animate({
			left: - slideWidth
		}, 200, function () {
			$('#slider ul li:first-child').appendTo('#slider ul');
			$('#slider ul').css('left', '');
		});
	};

	$('span.control_prev').click(function () {
		moveLeft();
	});

	$('span.control_next').click(function () {
		moveRight();
	});

	// Play videos on hover
	$('.animation-indicator').hover(
		function() {
			// play the video and hide the indicator
			$(this).fadeOut(100);
			$(this).next().get(0).play();
		}
	);
	$('video').mouseout(
		function () {
			$(this).get(0).pause();
			$(this).prev().fadeIn(100);
		}
	);


	//parallax
	$('body').each(function () {
		var o = $(this); // assigning the object

		$(window).scroll(function () {
			// Scroll the background at var speed
			// the yPos is a negative value because we're scrolling it UP!
			var yPos = (($(window).scrollTop() - o.offset().top) / o.data('speed'));

			// Put together our final background position
			var coords = '50% ' + yPos + 'px';

			// Move the background
			$('body').css({
				backgroundPosition: coords
			});
		});
	});

});