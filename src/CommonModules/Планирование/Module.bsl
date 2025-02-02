////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции планирования
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроцедурыКроссТаблиц
 
// Процедура заполняет таблицу периодов, последовательно датам с заданной периодичностью, для получения полей и их заголовков
//
// Параметры:
//  ТаблицаПериоды			 - ТаблицаЗначений		 - Таблица, которую заполняем отрезками заданной периодичности
//  Периодичность			 - ПеречислениеСсылка.Периодичность	 - Периодичность с которой нужно заполнить таблицу
//  ДатаНачала				 - Дата								 - Дата начала периода
//  ДатаОкончания			 - Дата								 - Дата окончания периода
//  ОтображатьНомерПериода	 - Булево							 - Флаг отображения заголовка по номеру периода в пределах года
//
Процедура ЗаполнитьТаблицуПериодов(ТаблицаПериоды, Знач Периодичность, Знач ДатаНачала, Знач ДатаОкончания, Знач ОтображатьНомерПериода = Ложь) Экспорт 

	Для каждого СтрокаПериода Из ТаблицаПериоды Цикл
		СтрокаПериода.Активная = Ложь;
		СтрокаПериода.НомерКолонки = -1;
	КонецЦикла; 
	
	Если НЕ ЗначениеЗаполнено(Периодичность)
		ИЛИ НЕ ЗначениеЗаполнено(ДатаНачала) 
		И НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавлениеДатаНачала = ПланированиеКлиентСервер.РассчитатьДатуНачалаПериода(ДатаНачала, Периодичность);
	ДобавлениеДатаОкончания = ПланированиеКлиентСервер.РассчитатьДатуОкончанияПериода(ДатаНачала, Периодичность);
	
	ТекущийПериод = 1;
	
	Пока ДобавлениеДатаНачала < КонецДня(ДатаОкончания) Цикл
		
		НайденныеСтроки = ТаблицаПериоды.НайтиСтроки(Новый Структура("ДатаНачала, ДатаОкончания", ДобавлениеДатаНачала, ДобавлениеДатаОкончания));
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаПериоды.Добавить();
			НоваяСтрока.ИмяКолонки = СтрЗаменить(Строка(Новый УникальныйИдентификатор),"-","_");
		Иначе
			НоваяСтрока = НайденныеСтроки[0];
		КонецЕсли;
		НоваяСтрока.НомерКолонки = ТекущийПериод;
		НоваяСтрока.Активная = Истина;
		НоваяСтрока.ДатаНачала = ДобавлениеДатаНачала;
		НоваяСтрока.ДатаОкончания = ДобавлениеДатаОкончания;
		НоваяСтрока.Заголовок = СформироватьЗаголовокПериода(Периодичность, ДобавлениеДатаНачала, ДобавлениеДатаОкончания, ОтображатьНомерПериода);
		
		ТекущийПериод = ТекущийПериод + 1;
		
		ДобавлениеДатаНачала = ПланированиеКлиентСервер.РассчитатьДатуНачалаПериода(ДобавлениеДатаОкончания+1 , Периодичность);
		ДобавлениеДатаОкончания = ПланированиеКлиентСервер.РассчитатьДатуОкончанияПериода(ДобавлениеДатаОкончания+1, Периодичность);
		
	КонецЦикла; 
	
	ТаблицаПериоды.Сортировать("НомерКолонки");
	
КонецПроцедуры

// Формирует заголовок для интервала дат с заданной периодичностью (День, неделя, декада, месяц и т.д.)
//
// Параметры:
//  Периодичность			 - ПеречислениеСсылка.Периодичность	 - Периодичность для которой нужно сформировать заголовок
//  ДатаНачала				 - Дата								 - Дата начала периода
//  ДатаОкончания			 - Дата								 - Дата окончания периода
//  ОтображатьНомерПериода	 - Булево							 - Флаг отображения заголовка по номеру периода в пределах года
// 
// Возвращаемое значение:
//  Строка - Текстовое представление заголовка периода
//
Функция СформироватьЗаголовокПериода(Знач Периодичность, Знач ДатаНачала, Знач ДатаОкончания, Знач ОтображатьНомерПериода = Ложь) Экспорт
	
	Заголовок = "";
	
	Если Периодичность = Перечисления.Периодичность.День Тогда
		Если ОтображатьНомерПериода Тогда
			Заголовок = Формат(ДеньГода(ДатаНачала), "ЧДЦ=0; ЧГ=0") + " " + НСтр("en='day';ru='день'");
		Иначе
			Заголовок = Формат(ДатаНачала, "ДЛФ=D");
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		Если ОтображатьНомерПериода Тогда
			Заголовок = НСтр("en='%НомерНедели% week';ru='%НомерНедели% неделя'");
			Если Год(ДатаНачала) <> Год(ДатаОкончания) Тогда
				НомерНедели = Формат(НеделяГода(ДатаНачала), "ЧДЦ=0; ЧГ=0") + "/" +  Формат(НеделяГода(ДатаОкончания), "ЧДЦ=0; ЧГ=0");
			Иначе
				НомерНедели = Формат(НеделяГода(ДатаНачала), "ЧДЦ=0; ЧГ=0");
			КонецЕсли; 
			Заголовок = СтрЗаменить(Заголовок, "%НомерНедели%", НомерНедели);
		Иначе
			ТекстДатаНачала = Формат(НачалоДня(ДатаНачала)+1, "ДФ=dd.MM"); 
			ТекстДатаОкончания = Формат(ДатаОкончания, "ДФ=dd.MM");
			Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("en='%1 - %2';ru='%1 - %2'"), ТекстДатаНачала, ТекстДатаОкончания);
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		ТекстДатаНачала = Формат(НачалоДня(ДатаНачала)+1, "ДФ=dd.MM"); 
		ТекстДатаОкончания = Формат(ДатаОкончания, "ДФ=dd.MM");
		Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("en='%1 - %2';ru='%1 - %2'"), ТекстДатаНачала, ТекстДатаОкончания);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		Если ОтображатьНомерПериода Тогда
			Заголовок = Формат(Месяц(НачалоДня(ДатаНачала)+1), "ЧДЦ=0; ЧГ=0") + " " + НСтр("en='month';ru='месяц'");
		Иначе
			Заголовок = Формат(НачалоДня(ДатаНачала)+1, "ДФ='MMMM yyyy'");
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		Если ОтображатьНомерПериода Тогда
			Заголовок = Формат(ДатаНачала, "ДФ='q'") + " " + НСтр("en='quarter';ru='квартал'");
		Иначе
			ТекстДатаНачала = Формат(ДатаНачала, "ДФ='q'");
			ТекстДатаОкончания = Формат(ДатаНачала, "ДФ=yyyy");
			ТекстНСТР = НСтр("en='%1Q %2';ru='%1 кв. %2'");
			Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНСТР, ТекстДатаНачала, ТекстДатаОкончания);
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		Если ОтображатьНомерПериода Тогда
			Заголовок = ?(ДатаНачала=НачалоГода(ДатаНачала),"1", "2");
		Иначе
			ТекстДатаНачала = ?(ДатаНачала=НачалоГода(ДатаНачала),"1", "2");
			ТекстДатаОкончания = Формат(ДатаНачала, "ДФ=yyyy");
			ТекстНСТР = НСтр("en='%1 half year %2';ru='%1 полугодие %2'");
			Заголовок   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНСТР, ТекстДатаНачала, ТекстДатаОкончания);
		КонецЕсли;
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		Заголовок = Формат(ДатаНачала, "ДФ='yyyy ""г.""'");
	Иначе 
		Заголовок = Строка(ДатаНачала);
	КонецЕсли;
	
	Возврат Заголовок;

КонецФункции

#КонецОбласти

// Функция создает таблицу значений для заполнения периодами плана
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с колонками периодов
//
Функция ПолучитьТаблицуПериодов() Экспорт
	
	ОписаниеТиповЧ = ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(10, 0); 
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка");
	ОписаниеТиповДата = ОбщегоНазначенияУТ.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя);
	
	ТаблицаПериодов = Новый ТаблицаЗначений;
	ТаблицаПериодов.Колонки.Добавить("НомерКолонки",  ОписаниеТиповЧ);
	ТаблицаПериодов.Колонки.Добавить("ИмяКолонки",    ОписаниеТиповСтрока);
	ТаблицаПериодов.Колонки.Добавить("Активная",      ОписаниеТиповБулево);
	ТаблицаПериодов.Колонки.Добавить("ДатаНачала",    ОписаниеТиповДата);
	ТаблицаПериодов.Колонки.Добавить("ДатаОкончания", ОписаниеТиповДата);
	ТаблицаПериодов.Колонки.Добавить("Заголовок",     ОписаниеТиповСтрока);
	
	Возврат ТаблицаПериодов;

КонецФункции

#КонецОбласти
