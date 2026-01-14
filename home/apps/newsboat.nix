{
  ...
}:

{
  programs.newsboat = {
    enable = true;
    autoReload = true;
    autoVacuum = {
      enable = true;
      onCalendar = "weekly";
    };
    autoFetchArticles = {
      enable = true;
      onCalendar = "hourly";
    };
    urls = [
      {
        title = "Phoronix";
        # tags = [ ];
        url = "https://www.phoronix.com/rss.php";
      }
      {
        title = "Tweakers";
        url = "https://tweakers.net/feeds/mixed.xml";
      }
      {
        title = "NOS Algemeen";
        url = "https://feeds.nos.nl/nosnieuwsalgemeen";
      }
      {
        title = "NOS Economie";
        url = "https://feeds.nos.nl/nosnieuwseconomie";
      }
      {
        title = "Yahoo Finance";
        url = "https://finance.yahoo.com/news/rss";
      }
    ];
  };
}
