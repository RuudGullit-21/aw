
#Область ОписаниеПеременных

&НаСервере
Перем Цвет1;

Перем Цвет2;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДатаКон = НачалоМесяца(ТекущаяДата())-1;
	ДатаНач = НачалоМесяца(ДатаКон);
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(Сортировка) Тогда
		Сортировка = "По ТС";
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(КонтрольСуммы) Тогда
		КонтрольСуммы = 1;
	КонецЕсли;
	ТСВыбыло = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПериода(Команда)
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогПериода.Период.ДатаНачала = ДатаНач;
	ДиалогПериода.Период.ДатаОкончания = ДатаКон;
	ДиалогПериода.Показать(Новый ОписаниеОповещения("НастройкаПериодаЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	Если НЕ ЗначениеЗаполнено(Сортировка) Тогда
		ТекстНСТР = НСтр("en='Not specified sort variant!';ru='Не указан вариант сортировки!'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстНСТР = НСтр("en='Not selected company!';ru='Не выбрана организация!'");
		ПоказатьПредупреждение(Неопределено, ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	// Проверка даты начала и окончания периода
	Если ДатаНач > ДатаКон Тогда
		ТекстСообщения = НСтр("en='Period start date cannot be greater than the period end date';ru='Дата начала периода не может быть больше даты конца периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	СформироватьОтчетСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтрокаСортировки()
	Если Сортировка = "По карте" Тогда
		Рез = "ПластиковаяКартаПредставление, ДатаОбщ, ТСПредставление";
	ИначеЕсли Сортировка = "По дате заправки" Тогда
		Рез = "ДатаОбщ, ПластиковаяКартаПредставление, ТСПредставление";
	Иначе
		Рез = "ТСПредставление, ДатаОбщ, ПластиковаяКартаПредставление";
	КонецЕсли;
	
	Возврат Рез;
КонецФункции

&НаСервере
Функция МодульЧисла(ТекЧисло)
	Возврат ?(ТекЧисло > 0, ТекЧисло, -ТекЧисло);
КонецФункции

// Основная процедура формирования отчета.
// Формирует отчет в виде табличного документа.
//
// Параметры:
//	ТабДок - табличный документ, куда будет выведен отчет,
//	АЗС, Организация - Отборы по АЗС и Организации,
//	ДатаКон, ДатаНач - период формирования отчета.
//
&НаСервере
Процедура СформироватьОтчетСервер()
	Макет = Отчеты.уатСравнениеЗаправокПоПластиковымКартам.ПолучитьМакет("Отчет");
	
	ЗапросПЦ = Новый Запрос;
	ЗапросПЦ.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатОборотыПоОтчетамПоставщиковПЦ.ТС,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Номенклатура КАК ГСМ,
	|	уатОборотыПоОтчетамПоставщиковПЦ.ПластиковаяКарта,
	|	уатОборотыПоОтчетамПоставщиковПЦ.ПластиковаяКартаОтчета,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Количество,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Стоимость - уатОборотыПоОтчетамПоставщиковПЦ.СуммаНДС КАК Стоимость,
	|	уатОборотыПоОтчетамПоставщиковПЦ.СуммаНДС,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Стоимость КАК Всего,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Валюта,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоОтчетамПоставщиковПЦ.Период, ДЕНЬ) КАК Дата,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Период КАК ДатаВремя,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Регистратор.Номер КАК Номер,
	|	уатОборотыПоОтчетамПоставщиковПЦ.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.уатОборотыПоОтчетамПоставщиковПЦ КАК уатОборотыПоОтчетамПоставщиковПЦ
	|ГДЕ
	|	уатОборотыПоОтчетамПоставщиковПЦ.Организация = &Организация
	|" + ?(НЕ ЗначениеЗаполнено(АЗС), "", "И уатОборотыПоОтчетамПоставщиковПЦ.АЗС = &АЗС") + "
	|	И уатОборотыПоОтчетамПоставщиковПЦ.Период МЕЖДУ &ДатаНач И &ДатаКон
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Количество,
	|	Стоимость";

	ЗапросПЦ.УстановитьПараметр("ДатаКон", ?(ДатаКон = '00010101', '39991231', КонецДня(ДатаКон)));
	ЗапросПЦ.УстановитьПараметр("ДатаНач", ДатаНач);
	ЗапросПЦ.УстановитьПараметр("АЗС", АЗС);
	ЗапросПЦ.УстановитьПараметр("Организация", Организация);
	
	ТаблицаПЦ = ЗапросПЦ.Выполнить().Выгрузить();
	
	// заполняем представление пластик. карт
	ТаблицаПЦ.Колонки.Добавить("ПластиковаяКартаПредставление");
	Для Каждого ТекСтрока Из ТаблицаПЦ Цикл
		Если ЗначениеЗаполнено(ТекСтрока.ПластиковаяКарта) Тогда
			ТекСтрока.ПластиковаяКартаПредставление = СокрЛП(ТекСтрока.ПластиковаяКарта);
		Иначе
			ТекСтрока.ПластиковаяКартаПредставление = СокрЛП(ТекСтрока.ПластиковаяКартаОтчета);
		КонецЕсли;
	КонецЦикла;

	// запрос по ручным заправкам и сливамм
	ЗапросГСМ = Новый Запрос;
	ЗапросГСМ.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатЗаправкаГСМЗаправки.ТС КАК ТС,
	|	уатЗаправкаГСМЗаправки.ГСМ КАК ГСМ,
	|	уатЗаправкаГСМЗаправки.ПластиковаяКарта КАК ПластиковаяКарта,
	|	уатЗаправкаГСМЗаправки.ВидЗаправки КАК ВидДвиженияГСМ,
	|	уатЗаправкаГСМЗаправки.КоличествоОборот КАК Количество,
	|	уатЗаправкаГСМЗаправки.СтоимостьОборот - уатЗаправкаГСМЗаправки.СуммаНДСОборот КАК Стоимость,
	|	уатЗаправкаГСМЗаправки.СуммаНДСОборот КАК СуммаНДС,
	|	уатЗаправкаГСМЗаправки.СтоимостьОборот КАК Всего,
	|	НАЧАЛОПЕРИОДА(уатЗаправкаГСМЗаправки.Период, ДЕНЬ) КАК Дата,
	|	уатЗаправкаГСМЗаправки.Период КАК ДатаВремя,
	|	уатЗаправкаГСМЗаправки.Регистратор.Номер КАК Номер,
	|	уатЗаправкаГСМЗаправки.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.уатОборотыПоЗаправкамГСМ.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК уатЗаправкаГСМЗаправки
	|ГДЕ
	|	(уатЗаправкаГСМЗаправки.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаПластиковаяКарта)
	|			ИЛИ уатЗаправкаГСМЗаправки.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаПластиковаяКартаСклад))
	|	И уатЗаправкаГСМЗаправки.Организация = &Организация
	|	И (&ПустаяАЗС
	|			ИЛИ уатЗаправкаГСМЗаправки.АЗС = &АЗС)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатСливГСМ.ТС,
	|	уатСливГСМ.ГСМ,
	|	"""",
	|	NULL,
	|	-уатСливГСМ.Количество,
	|	0,
	|	0,
	|	0,
	|	НАЧАЛОПЕРИОДА(уатСливГСМ.Дата, ДЕНЬ),
	|	уатСливГСМ.Дата,
	|	уатСливГСМ.Номер,
	|	уатСливГСМ.Ссылка
	|ИЗ
	|	Документ.уатСливГСМ КАК уатСливГСМ
	|ГДЕ
	|	уатСливГСМ.Организация = &Организация
	|	И (&ПустаяАЗС
	|			ИЛИ уатСливГСМ.АЗС = &АЗС)
	|	И уатСливГСМ.Проведен
	|	И уатСливГСМ.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Количество,
	|	Стоимость";

	ЗапросГСМ.УстановитьПараметр("ДатаКон", ?(ДатаКон = '00010101', '39991231', КонецДня(ДатаКон)));
	ЗапросГСМ.УстановитьПараметр("ДатаНач", ДатаНач);
	ЗапросГСМ.УстановитьПараметр("АЗС", АЗС);
	ЗапросГСМ.УстановитьПараметр("ПустаяАЗС", НЕ ЗначениеЗаполнено(АЗС));
	ЗапросГСМ.УстановитьПараметр("Организация", Организация);
	
	ТаблицаГСМ = ЗапросГСМ.Выполнить().Выгрузить();
	
	// заполняем представление пластик. карт
	ТаблицаГСМ.Колонки.Добавить("ПластиковаяКартаПредставление");
	Для Каждого ТекСтрока Из ТаблицаГСМ Цикл
		ТекСтрока.ПластиковаяКартаПредставление = СокрЛП(ТекСтрока.ПластиковаяКарта);
	КонецЦикла;
	
	ТаблицаРезультат = Новый ТаблицаЗначений; //ТаблицаПЦ.Скопировать();
	ТаблицаРезультат.Колонки.Добавить("ТС");
	ТаблицаРезультат.Колонки.Добавить("ТСПредставление");
	ТаблицаРезультат.Колонки.Добавить("ПластиковаяКарта");
	ТаблицаРезультат.Колонки.Добавить("ПластиковаяКартаПредставление");
	                                                           
	ТаблицаРезультат.Колонки.Добавить("Дата1");
	ТаблицаРезультат.Колонки.Добавить("ДатаВремя1");
	ТаблицаРезультат.Колонки.Добавить("Номер1");
	ТаблицаРезультат.Колонки.Добавить("ГСМ1");
	ТаблицаРезультат.Колонки.Добавить("Количество1", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 
		уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, 
		ПланыВидовХарактеристик.уатПраваИНастройки.ТочностьОстатковТоплива), ДопустимыйЗнак.Любой)));
	ТаблицаРезультат.Колонки.Добавить("Стоимость1", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, 
		ДопустимыйЗнак.Неотрицательный)));
	ТаблицаРезультат.Колонки.Добавить("СуммаНДС1", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, 
		ДопустимыйЗнак.Неотрицательный)));
	ТаблицаРезультат.Колонки.Добавить("Всего1", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, 
		ДопустимыйЗнак.Неотрицательный)));
	ТаблицаРезультат.Колонки.Добавить("Регистратор1");

	ТаблицаРезультат.Колонки.Добавить("Дата2");
	ТаблицаРезультат.Колонки.Добавить("ДатаВремя2");
	ТаблицаРезультат.Колонки.Добавить("Номер2");
	ТаблицаРезультат.Колонки.Добавить("ГСМ2");
	ТаблицаРезультат.Колонки.Добавить("Количество2", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 
		уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, 
		ПланыВидовХарактеристик.уатПраваИНастройки.ТочностьОстатковТоплива), ДопустимыйЗнак.Любой)));
	ТаблицаРезультат.Колонки.Добавить("Стоимость2", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, 
		ДопустимыйЗнак.Неотрицательный)));
	ТаблицаРезультат.Колонки.Добавить("СуммаНДС2", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, 
		ДопустимыйЗнак.Неотрицательный)));
	ТаблицаРезультат.Колонки.Добавить("Всего2", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2, 
		ДопустимыйЗнак.Неотрицательный)));
	ТаблицаРезультат.Колонки.Добавить("Регистратор2");
	
	ТаблицаРезультат.Колонки.Добавить("ПометитьКрасным");

	// первый проход - проверяем таблицу ПЦ
	Для Каждого ТекСтрока Из ТаблицаПЦ Цикл
		Отбор = Новый Структура;
		
		Если ТекСтрока.Количество > 0 Тогда
			Отбор.Вставить("ПластиковаяКартаПредставление", ТекСтрока.ПластиковаяКартаПредставление);
		КонецЕсли;
		Отбор.Вставить("Дата", ТекСтрока.Дата);
		Отбор.Вставить("ГСМ", ТекСтрока.ГСМ);
		Отбор.Вставить("Количество", ТекСтрока.Количество);
		//Отбор.Вставить("Стоимость", ТекСтрока.Стоимость);
		
		НоваяСтрока					= ТаблицаРезультат.Добавить();
		НоваяСтрока.ТС 				= ТекСтрока.ТС;
		НоваяСтрока.ТСПредставление	= Строка(ТекСтрока.ТС);
		
		НоваяСтрока.ПластиковаяКарта = ТекСтрока.ПластиковаяКарта;
		НоваяСтрока.ПластиковаяКартаПредставление = ТекСтрока.ПластиковаяКартаПредставление;
		Если НЕ ЗначениеЗаполнено(ТекСтрока.ПластиковаяКарта) Тогда
			НоваяСтрока.ПометитьКрасным  = Истина;
		КонецЕсли;
					
		НоваяСтрока.ГСМ1 			= ТекСтрока.ГСМ;
		НоваяСтрока.Дата1 			= ТекСтрока.Дата;
		НоваяСтрока.ДатаВремя1 		= ТекСтрока.ДатаВремя;
		НоваяСтрока.Номер1 			= ТекСтрока.Номер;
		НоваяСтрока.Количество1 	= ТекСтрока.Количество;
		НоваяСтрока.Стоимость1 		= ТекСтрока.Стоимость;
		НоваяСтрока.СуммаНДС1 		= ТекСтрока.СуммаНДС;
		НоваяСтрока.Всего1 			= ТекСтрока.Всего;
		НоваяСтрока.Регистратор1 	= ТекСтрока.Регистратор;
			
		// ищем совпадающие заправки
		мСтроки = ТаблицаГСМ.НайтиСтроки(Отбор);
		Если мСтроки.Количество() > 0 Тогда
			// есть совпадения
			Если мСтроки.Количество() = 1 Тогда
				мСтрока = мСтроки[0];
			Иначе
				// Если совпадений по количеству много, то выбираем равную
				// или наиболее близкую по стоимости заправку
				РазницаСтоимости = МодульЧисла(мСтроки[0].Стоимость - ТекСтрока.Стоимость);
				Если РазницаСтоимости = 0 Тогда //если первая строка с нулевой разницей - то берем ее
					мСтрока = мСтроки[0];
				Иначе
					ИндексСтроки = 0;
					ИндексСтрокиПоиска = 0;
					Для Каждого ТекСтрокаТабГСМ Из мСтроки Цикл
						ТекРазницаСтоимости = МодульЧисла(ТекСтрокаТабГСМ.Стоимость - ТекСтрока.Стоимость);
						Если ТекРазницаСтоимости < РазницаСтоимости Тогда
							ИндексСтрокиПоиска = ИндексСтроки;
						КонецЕсли;
						
						ИндексСтроки = ИндексСтроки + 1;
					КонецЦикла;
					мСтрока = мСтроки[ИндексСтрокиПоиска];
				КонецЕсли;
			КонецЕсли;
			
			НоваяСтрока.ГСМ2 			= мСтрока.ГСМ;
			НоваяСтрока.Дата2 			= мСтрока.Дата;
			НоваяСтрока.ДатаВремя2 		= мСтрока.ДатаВремя;
			НоваяСтрока.Номер2 			= мСтрока.Номер;
			НоваяСтрока.Количество2 	= мСтрока.Количество;
			НоваяСтрока.Стоимость2 		= мСтрока.Стоимость;
			НоваяСтрока.СуммаНДС2 		= мСтрока.СуммаНДС;
			НоваяСтрока.Всего2 			= мСтрока.Всего;
			НоваяСтрока.Регистратор2 	= мСтрока.Регистратор;
			
			ТаблицаГСМ.Удалить(мСтрока);
		КонецЕсли;	
	КонецЦикла;
	
	// второй проход - проверяем таблицу ручных заправок
	Для Каждого ТекСтрока Из ТаблицаГСМ Цикл
		НоваяСтрока					 = ТаблицаРезультат.Добавить();
		НоваяСтрока.ТС 				 = ТекСтрока.ТС;
		НоваяСтрока.ТСПредставление	 = Строка(ТекСтрока.ТС);
		
		НоваяСтрока.ПластиковаяКарта = ТекСтрока.ПластиковаяКарта;
		НоваяСтрока.ПластиковаяКартаПредставление = ТекСтрока.ПластиковаяКартаПредставление;
					
		НоваяСтрока.ГСМ2 			 = ТекСтрока.ГСМ;
		НоваяСтрока.Дата2 			 = ТекСтрока.Дата;
		НоваяСтрока.ДатаВремя2		 = ТекСтрока.ДатаВремя;
		НоваяСтрока.Номер2 			 = ТекСтрока.Номер;
		НоваяСтрока.Количество2 	 = ТекСтрока.Количество;
		НоваяСтрока.Стоимость2 		 = ТекСтрока.Стоимость;
		НоваяСтрока.СуммаНДС2 		 = ТекСтрока.СуммаНДС;
		НоваяСтрока.Всего2 			 = ТекСтрока.Всего;
		НоваяСтрока.Регистратор2 	 = ТекСтрока.Регистратор;
	КонецЦикла;
	
	// добавляем колонку ДатаОбщ для сортировке по дате
	ТаблицаРезультат.Колонки.Добавить("ДатаОбщ");
	Для Каждого ТекСтрока Из ТаблицаРезультат Цикл
		// "общая" дата
		Если ТекСтрока.ДатаВремя1 = Неопределено Тогда
			ТекСтрока.ДатаОбщ = ТекСтрока.ДатаВремя2;
		Иначе
			ТекСтрока.ДатаОбщ = ТекСтрока.ДатаВремя1;
		КонецЕсли;
		// заполняем количество и стоимость, если неопределено
		Если ТекСтрока.Количество1 = Неопределено Тогда
			ТекСтрока.Количество1 = 0;
		КонецЕсли;
		Если ТекСтрока.Количество2 = Неопределено Тогда
			ТекСтрока.Количество2 = 0;
		КонецЕсли;
		Если ТекСтрока.Стоимость1 = Неопределено Тогда
			ТекСтрока.Стоимость1 = 0;
		КонецЕсли;
		Если ТекСтрока.Стоимость2 = Неопределено Тогда
			ТекСтрока.Стоимость2 = 0;
		КонецЕсли;
	КонецЦикла;
	
	//сортируем
	ТаблицаРезультат.Сортировать(СтрокаСортировки());
	
	ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал 			= Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы 	= Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы 	= Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	Для Каждого ТекСтрока Из ТаблицаРезультат Цикл
		Если КонтрольСуммы = 1 Тогда
			ФильтрОтображатьТолькоРазличные = ТекСтрока.Количество1 = ТекСтрока.Количество2 И ТекСтрока.Стоимость1 = ТекСтрока.Стоимость2
				И ТекСтрока.СуммаНДС1 = ТекСтрока.СуммаНДС2 И ТекСтрока.Всего1 = ТекСтрока.Всего2 И ОтображатьТолькоРазличные;
		Иначе
			ФильтрОтображатьТолькоРазличные = ТекСтрока.Количество1 = ТекСтрока.Количество2 И ОтображатьТолькоРазличные;
		КонецЕсли;
		
		Если ФильтрОтображатьТолькоРазличные Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ТекСтрока);
		Если ТекСтрока.ПометитьКрасным = Истина Тогда
			ОбластьДетальныхЗаписей.Области.ПластиковаяКарта.ЦветТекста = WebЦвета.Красный;
		Иначе
			ОбластьДетальныхЗаписей.Области.ПластиковаяКарта.ЦветТекста = ЦветаСтиля.ЦветТекстаПоля;
		КонецЕсли;
		
		Если НЕ НеРаскрашивать Тогда // раскраска
			Если ТекСтрока.Количество1 = 0 И ТекСтрока.Количество2 = 0 Тогда //нулевые не красим вообще
				ОбластьДетальныхЗаписей.Области.Количество1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
				ОбластьДетальныхЗаписей.Области.Количество2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
			Иначе
				Если ТекСтрока.Количество1 <> ТекСтрока.Количество2 Тогда //не соответствуют - красные
					Если ТекСтрока.Количество1 = 0 Тогда
						ОбластьДетальныхЗаписей.Области.Количество1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					Иначе
						ОбластьДетальныхЗаписей.Области.Количество1.ЦветФона = Цвет2;
					КонецЕсли;
					Если ТекСтрока.Количество2 = 0 Тогда
						ОбластьДетальныхЗаписей.Области.Количество2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					Иначе
						ОбластьДетальныхЗаписей.Области.Количество2.ЦветФона = Цвет2;
					КонецЕсли;
				Иначе //соответствуют - зеленые
					//ОбластьДетальныхЗаписей.Области.Количество1.ЦветФона = Цвет1;
					//ОбластьДетальныхЗаписей.Области.Количество2.ЦветФона = Цвет1;
					ОбластьДетальныхЗаписей.Области.Количество1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					ОбластьДетальныхЗаписей.Области.Количество2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
				КонецЕсли;
			КонецЕсли;
			
			Если КонтрольСуммы = 1 Тогда
				Если ТекСтрока.Стоимость1 = 0 И ТекСтрока.Стоимость2 = 0 Тогда //нулевые не красим вообще
					ОбластьДетальныхЗаписей.Области.Стоимость1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					ОбластьДетальныхЗаписей.Области.Стоимость2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
				Иначе
					Если ТекСтрока.Стоимость1 <> ТекСтрока.Стоимость2 Тогда //не соответствуют - красные
						Если ТекСтрока.Стоимость1 = 0 Тогда
							ОбластьДетальныхЗаписей.Области.Стоимость1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						Иначе
							ОбластьДетальныхЗаписей.Области.Стоимость1.ЦветФона = Цвет2;
						КонецЕсли;
						Если ТекСтрока.Стоимость2 = 0 Тогда
							ОбластьДетальныхЗаписей.Области.Стоимость2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						Иначе
							ОбластьДетальныхЗаписей.Области.Стоимость2.ЦветФона = Цвет2;
						КонецЕсли;
					Иначе //соответствуют - зеленые
						//ОбластьДетальныхЗаписей.Области.Стоимость1.ЦветФона = Цвет1;
						//ОбластьДетальныхЗаписей.Области.Стоимость2.ЦветФона = Цвет1;
						ОбластьДетальныхЗаписей.Области.Стоимость1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						ОбластьДетальныхЗаписей.Области.Стоимость2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					КонецЕсли;
				КонецЕсли;
				
				Если ТекСтрока.СуммаНДС1 = 0 И ТекСтрока.СуммаНДС2 = 0 Тогда //нулевые не красим вообще
					ОбластьДетальныхЗаписей.Области.СуммаНДС1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					ОбластьДетальныхЗаписей.Области.СуммаНДС2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
				Иначе
					Если ТекСтрока.СуммаНДС1 <> ТекСтрока.СуммаНДС2 Тогда //не соответствуют - красные
						Если ТекСтрока.СуммаНДС1 = 0 Тогда
							ОбластьДетальныхЗаписей.Области.СуммаНДС1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						Иначе
							ОбластьДетальныхЗаписей.Области.СуммаНДС1.ЦветФона = Цвет2;
						КонецЕсли;
						Если ТекСтрока.СуммаНДС2 = 0 Тогда
							ОбластьДетальныхЗаписей.Области.СуммаНДС2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						Иначе
							ОбластьДетальныхЗаписей.Области.СуммаНДС2.ЦветФона = Цвет2;
						КонецЕсли;
					Иначе //соответствуют - зеленые
						//ОбластьДетальныхЗаписей.Области.СуммаНДС1.ЦветФона = Цвет1;
						//ОбластьДетальныхЗаписей.Области.СуммаНДС2.ЦветФона = Цвет1;
						ОбластьДетальныхЗаписей.Области.СуммаНДС1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						ОбластьДетальныхЗаписей.Области.СуммаНДС2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					КонецЕсли;
				КонецЕсли;
				
				Если ТекСтрока.Всего1 = 0 И ТекСтрока.Всего2 = 0 Тогда //нулевые не красим вообще
					ОбластьДетальныхЗаписей.Области.Всего1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					ОбластьДетальныхЗаписей.Области.Всего2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
				Иначе
					Если ТекСтрока.Всего1 <> ТекСтрока.Всего2 Тогда //не соответствуют - красные
						Если ТекСтрока.Всего1 = 0 Тогда
							ОбластьДетальныхЗаписей.Области.Всего1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						Иначе
							ОбластьДетальныхЗаписей.Области.Всего1.ЦветФона = Цвет2;
						КонецЕсли;
						Если ТекСтрока.Всего2 = 0 Тогда
							ОбластьДетальныхЗаписей.Области.Всего2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						Иначе
							ОбластьДетальныхЗаписей.Области.Всего2.ЦветФона = Цвет2;
						КонецЕсли;
					Иначе //соответствуют - зеленые
						//ОбластьДетальныхЗаписей.Области.Всего1.ЦветФона = Цвет1;
						//ОбластьДетальныхЗаписей.Области.Всего2.ЦветФона = Цвет1;
						ОбластьДетальныхЗаписей.Области.Всего1.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
						ОбластьДетальныхЗаписей.Области.Всего2.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
	
	// Зафиксируем заголовок отчета
	ТабДок.ФиксацияСверху 	= 6;
	ТабДок.ПолеСлева 		= 0;
	ТабДок.ПолеСправа 		= 0;

КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериодаЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Не Период = Неопределено Тогда
		ДатаНач = Период.ДатаНачала;
		ДатаКон = Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИсполняемаяЧастьМодуля

Цвет1 = Новый Цвет(220, 255, 220); // Зеленый
Цвет2 = Новый Цвет(255, 235, 220); // Красный

#КонецОбласти