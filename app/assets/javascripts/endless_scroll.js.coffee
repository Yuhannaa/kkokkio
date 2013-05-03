jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 150
        $('.pagination').html("<p><i class='icon-time'></i> 불러오는 중..</p>")
        $.getScript(url)
    $(window).scroll