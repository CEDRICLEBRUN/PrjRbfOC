from datetime import date, datetime, timedelta
import locale
import pytz
import holidays

def initialise_date(deltadays: int=0, timezone='Europe/Paris', local_language='fr_FR', holidays_country='FR'):
    '''
    Générer plusieurs dates dans un objet contenant :
    la date du jour, la veille, le lendemain 
    et une nouvelle date calculée par un décallage en nombre de jour
    Plusieurs informations sont remontées : 
    Pays, Jours fériés, weekend et différents formats
    '''
    assert timezone in pytz.all_timezones
    assert local_language in [x.split(".")[0] for x in list(locale.locale_alias.values())]
    assert holidays_country in list(holidays.list_supported_countries().keys())
    locale.setlocale(locale.LC_TIME, local_language)
    holidays_list = holidays.country_holidays(holidays_country)
    
    dic = {}
    dic['timezone'] = timezone
    dic['localLanguage'] = local_language
    dic['holidaysCountry'] = holidays_country

    def create_data(dt, key): 
        dic[key] = {}
        # dic[key]['date'] = dt.date()
        dic[key]['isWeekends'] = False if dt.weekday() < 5 else True
        dic[key]['isHolidays'] = holidays_list.get(dt) if dt in holidays_list else ""
        dic[key]['day'] = dt.day
        dic[key]['dd'] = dt.strftime("%d")
        dic[key]['day_short'] = dt.strftime("%a")
        dic[key]['day_long'] = dt.strftime("%A")
        dic[key]['month'] = dt.month
        dic[key]['mm'] = dt.strftime("%m")
        dic[key]['month_short'] = dt.strftime("%b")
        dic[key]['month_long'] = dt.strftime("%B")
        dic[key]['year'] = dt.year
        dic[key]['yy'] = dt.strftime("%y")
        dic[key]['d/m/Y'] = dt.strftime("%d/%m/%Y")
        dic[key]['Y-m-d'] = dt.strftime("%Y-%m-%d")
        dic[key]['formatLocal'] = dt.strftime("%x")
        dic[key]['week'] = dt.isocalendar()[1]
        if date.today() == dt.date():
            dic[key]['H:M'] = dt.strftime("%H:%M")
            locale.setlocale(locale.LC_TIME, 'en_US')
            dic[key]['ampm'] = dt.strftime("%p")
            dic[key]['I:M'] = dt.strftime("%I:%M")
            locale.setlocale(locale.LC_TIME, local_language)

    dt_now = datetime.now(pytz.timezone(timezone))
    dt_yesterday = dt_now - timedelta(days = 1)
    dt_tomorrow = dt_now + timedelta(days = 1)
    dt_newdate = dt_now + timedelta(days = deltadays)

    create_data(dt_now, "now")
    create_data(dt_yesterday, "yesterday")
    create_data(dt_tomorrow, "tomorrow")
    create_data(dt_newdate, "newdate")

    dic['deltadays'] = deltadays 
    dic['deltamonth'] = dt_newdate.month - dt_now.month + 12 * (dt_newdate.year - dt_now.year)

    return dic

# import pprint
# pp = pprint.PrettyPrinter(indent=4, sort_dicts=False)
# pp.pprint(initialise_date(-10))
