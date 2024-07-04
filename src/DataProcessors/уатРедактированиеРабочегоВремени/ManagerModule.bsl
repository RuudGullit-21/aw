#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция читает данные графика из регистра
//
// Параметры:
//  Ресурсы			 - 	 - 
//  ДатаНачала		 - 	 - 
//  ДатаОкончания	 - 	 - 
//  ЭтоГрафик		 - 	 - 
// 
// Возвращаемое значение:
//  СписокЗначений - список значений, в котором хранятся даты, входящие в календарь
//
Функция РасписанияРаботыНаПериод(Ресурсы, ДатаНачала, ДатаОкончания, ЭтоГрафик = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	тзГрафики            = Ресурсы.Скопировать();
	тзГрафики.Свернуть("ГрафикРаботы");
	Графики              = тзГрафики.ВыгрузитьКолонку("ГрафикРаботы");
	
	тблРабочиеИнтервалыГрафиков = ГрафикиРаботы.РасписанияРаботыНаПериод(Графики, ДатаНачала - 24*3600, ДатаОкончания + 24*3600);
	
	тблРабочиеИнтервалыГрафиков.Колонки.Добавить("Время", Новый ОписаниеТипов("Число"));
	
	Если НЕ ЭтоГрафик Тогда
		тблРабочиеИнтервалыГрафиков.Колонки.Добавить("Регистратор", Новый ОписаниеТипов("ДокументСсылка.уатКорректировкаИспользованияРаботникамиРабочегоВремени"));
		тблРабочиеИнтервалыГрафиков.Колонки.Добавить("ВидВремени", Новый ОписаниеТипов("СправочникСсылка.уатВидыИспользованияРабочегоВремени"));
		
		тзСотрудникиИТС = Ресурсы.Скопировать();
		тзСотрудникиИТС.Свернуть("Сотрудник");
		уатОбщегоНазначения.ДобавитьКорректировкиРасписанияРаботыСотрудниковИТС(тблРабочиеИнтервалыГрафиков, тзСотрудникиИТС, ДатаНачала - 24*3600,
			ДатаОкончания + 24*3600);
	КонецЕсли;
			
	// типизация временных колонок меняется Время -> Дата+Время
	тблРабочиеИнтервалыГрафиков.Колонки.ВремяНачала.Имя    = "ВремяНачалаВремя";
	тблРабочиеИнтервалыГрафиков.Колонки.ВремяОкончания.Имя = "ВремяОкончанияВремя";
	тблРабочиеИнтервалыГрафиков.Колонки.Добавить("ВремяНачала", Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	тблРабочиеИнтервалыГрафиков.Колонки.Добавить("ВремяОкончания", Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	Для Каждого ТекРабочийИнтервал Из тблРабочиеИнтервалыГрафиков Цикл
		ТекРабочийИнтервал.ВремяНачала    = ТекРабочийИнтервал.ВремяНачалаВремя;
		ТекРабочийИнтервал.ВремяОкончания = ТекРабочийИнтервал.ВремяОкончанияВремя;
	КонецЦикла;
	
	// Если интервал заканчивается в полночь, то перещелкиваем окончание интервала на следующий день
	мсвСтрокиОкончаниеПолночь = тблРабочиеИнтервалыГрафиков.НайтиСтроки(Новый Структура("ВремяОкончания", '00010101'));
	Для Каждого ТекРабочийИнтервал Из мсвСтрокиОкончаниеПолночь Цикл
		ТекРабочийИнтервал.ВремяОкончания = '00010102';
	КонецЦикла;
	
	// Обработка незаполненных интервалов (в шаблоне указан день, но не указаны интервалы)
	//  - считаются круглосуточными от 0 до 0
	Для Каждого ТекРабочийИнтервал Из тблРабочиеИнтервалыГрафиков Цикл
		Если ТекРабочийИнтервал.ВремяНачала = NULL Тогда
			ТекРабочийИнтервал.ВремяНачала = '00010101';
			ТекРабочийИнтервал.ВремяОкончания = '00010102';
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("тзРесурсы", Ресурсы);
	Запрос.УстановитьПараметр("ВТРасписанияРаботы", тблРабочиеИнтервалыГрафиков);
	Если ЭтоГрафик Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасписанияРаботы.ГрафикРаботы КАК ГрафикРаботы,
		|	РасписанияРаботы.ДатаГрафика КАК ДатаГрафика,
		|	РасписанияРаботы.ВремяНачала КАК ВремяНачала,
		|	РасписанияРаботы.ВремяОкончания КАК ВремяОкончания,
		|	РасписанияРаботы.Время КАК Время
		|ПОМЕСТИТЬ втРасписаниеРаботы
		|ИЗ
		|	&ВТРасписанияРаботы КАК РасписанияРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВложенныйЗапрос.ГрафикРаботы КАК ГрафикРаботы,
		|	ВложенныйЗапрос.ДатаГрафика КАК ДатаГрафика,
		|	""ПоГрафику"" КАК ВидВремени,
		|	ВЫБОР
		|		КОГДА ВложенныйЗапрос.Время > 24
		|			ТОГДА 24
		|		ИНАЧЕ ВложенныйЗапрос.Время
		|	КОНЕЦ КАК Время,
		|	ВложенныйЗапрос.ВремяНачала КАК ВремяНачала,
		|	ВложенныйЗапрос.ВремяОкончания КАК ВремяОкончания
		|ПОМЕСТИТЬ втВремяПоГрафику
		|ИЗ
		|	(ВЫБРАТЬ
		|		втРасписаниеРаботы.ГрафикРаботы КАК ГрафикРаботы,
		|		втРасписаниеРаботы.ДатаГрафика КАК ДатаГрафика,
		|		СУММА(ВЫБОР
		|				КОГДА втРасписаниеРаботы.Время = 0
		|					ТОГДА РАЗНОСТЬДАТ(втРасписаниеРаботы.ВремяНачала, втРасписаниеРаботы.ВремяОкончания, СЕКУНДА) / 3600
		|				ИНАЧЕ втРасписаниеРаботы.Время
		|			КОНЕЦ) КАК Время,
		|		МИНИМУМ(втРасписаниеРаботы.ВремяНачала) КАК ВремяНачала,
		|		МАКСИМУМ(втРасписаниеРаботы.ВремяОкончания) КАК ВремяОкончания
		|	ИЗ
		|		втРасписаниеРаботы КАК втРасписаниеРаботы
		|	
		|	СГРУППИРОВАТЬ ПО
		|		втРасписаниеРаботы.ГрафикРаботы,
		|		втРасписаниеРаботы.ДатаГрафика) КАК ВложенныйЗапрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	тзРесурсы.ГрафикРаботы КАК ГрафикРаботы,
		|	тзРесурсы.Период КАК Период
		|ПОМЕСТИТЬ втДанныеРесурсов
		|ИЗ
		|	&тзРесурсы КАК тзРесурсы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	втДанныеРесурсов.ГрафикРаботы КАК ГрафикРаботы,
		|	втДанныеРесурсов.Период КАК ДатаГрафика,
		|	ЕСТЬNULL(втВремяПоГрафику.ВидВремени, """") КАК ВидВремени,
		|	ЕСТЬNULL(втВремяПоГрафику.Время, 0) КАК Время,
		|	втВремяПоГрафику.ВремяНачала КАК ВремяНачала,
		|	втВремяПоГрафику.ВремяОкончания КАК ВремяОкончания
		|ИЗ
		|	втДанныеРесурсов КАК втДанныеРесурсов
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВремяПоГрафику КАК втВремяПоГрафику
		|		ПО втДанныеРесурсов.ГрафикРаботы = втВремяПоГрафику.ГрафикРаботы
		|			И втДанныеРесурсов.Период = втВремяПоГрафику.ДатаГрафика";
		тблРез = Запрос.Выполнить().Выгрузить();
	Иначе
		Запрос.УстановитьПараметр("тзСотрудники", Ресурсы);
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасписанияРаботы.Сотрудник КАК Сотрудник,
		|	РасписанияРаботы.ГрафикРаботы КАК ГрафикРаботы,
		|	РасписанияРаботы.ДатаГрафика КАК ДатаГрафика,
		|	РасписанияРаботы.ВремяНачала КАК ВремяНачала,
		|	РасписанияРаботы.ВремяОкончания КАК ВремяОкончания,
		|	РасписанияРаботы.Регистратор КАК Регистратор,
		|	РасписанияРаботы.ВидВремени КАК ВидВремени,
		|	РасписанияРаботы.Время КАК Время
		|ПОМЕСТИТЬ втРасписаниеРаботы
		|ИЗ
		|	&ВТРасписанияРаботы КАК РасписанияРаботы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	тзСотрудники.Сотрудник КАК Сотрудник,
		|	тзСотрудники.Организация КАК Организация,
		|	тзСотрудники.Период КАК Период,
		|	тзСотрудники.ГрафикРаботы КАК ГрафикРаботы,
		|	тзСотрудники.ДатаПриема КАК ДатаПриема,
		|	тзСотрудники.ДатаУвольнения КАК ДатаУвольнения
		|ПОМЕСТИТЬ втДанныеСотрудников
		|ИЗ
		|	&тзСотрудники КАК тзСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	втДанныеСотрудников.Сотрудник КАК Сотрудник,
		|	втДанныеСотрудников.Организация КАК Организация,
		|	втДанныеСотрудников.ГрафикРаботы КАК ГрафикРаботы,
		|	втДанныеСотрудников.Период КАК ДатаГрафика,
		|	ВложенныйЗапрос.ВидВремени КАК ВидВремени,
		|	ВЫБОР
		|		КОГДА ВложенныйЗапрос.Время ЕСТЬ NULL
		|			ТОГДА """"
		|		ИНАЧЕ ""ПоГрафику""
		|	КОНЕЦ КАК РабочееВремя,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ВложенныйЗапрос.Время, 0) > 24
		|			ТОГДА 24
		|		ИНАЧЕ ЕСТЬNULL(ВложенныйЗапрос.Время, 0)
		|	КОНЕЦ КАК Время,
		|	ВложенныйЗапрос.ВремяНачала КАК ВремяНачала,
		|	ВложенныйЗапрос.ВремяОкончания КАК ВремяОкончания,
		|	втДанныеСотрудников.ДатаПриема КАК ДатаПриема,
		|	втДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
		|	ВложенныйЗапрос.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ втВремяПоГрафику
		|ИЗ
		|	втДанныеСотрудников КАК втДанныеСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			втРасписаниеРаботы.ГрафикРаботы КАК ГрафикРаботы,
		|			втРасписаниеРаботы.Сотрудник КАК Сотрудник,
		|			втРасписаниеРаботы.ДатаГрафика КАК ДатаГрафика,
		|			ВЫБОР
		|				КОГДА втРасписаниеРаботы.Время = 0
		|					ТОГДА РАЗНОСТЬДАТ(втРасписаниеРаботы.ВремяНачала, втРасписаниеРаботы.ВремяОкончания, СЕКУНДА) / 3600
		|				ИНАЧЕ втРасписаниеРаботы.Время
		|			КОНЕЦ КАК Время,
		|			втРасписаниеРаботы.ВремяНачала КАК ВремяНачала,
		|			втРасписаниеРаботы.ВремяОкончания КАК ВремяОкончания,
		|			втРасписаниеРаботы.Регистратор КАК Регистратор,
		|			втРасписаниеРаботы.ВидВремени КАК ВидВремени
		|		ИЗ
		|			втРасписаниеРаботы КАК втРасписаниеРаботы) КАК ВложенныйЗапрос
		|		ПО втДанныеСотрудников.ГрафикРаботы = ВложенныйЗапрос.ГрафикРаботы
		|			И втДанныеСотрудников.Сотрудник = ВложенныйЗапрос.Сотрудник
		|			И втДанныеСотрудников.Период = ВложенныйЗапрос.ДатаГрафика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	втДанныеСотрудников.Период КАК ДатаГрафика,
		|	втДанныеСотрудников.Сотрудник КАК Сотрудник,
		|	втДанныеСотрудников.Организация КАК Организация,
		|	втДанныеСотрудников.ГрафикРаботы КАК ГрафикРаботы,
		|	уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени КАК ВидВремени,
		|	ВЫБОР
		|		КОГДА уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени.ИспользоватьКакРабочееВремя = ИСТИНА
		|			ТОГДА ""Рабочее""
		|		ИНАЧЕ ""НеРабочее""
		|	КОНЕЦ КАК РабочееВремя,
		|	МАКСИМУМ(уатРабочееВремяСотрудниковОбороты.ВремяОборот / 3600) КАК Время,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ВремяНачала,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ВремяОкончания,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ДатаПриема,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ДатаУвольнения,
		|	ЕСТЬNULL(ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(уатРабочееВремяСотрудниковОбороты.Регистратор) = ТИП(Документ.уатПутевойЛист)
		|				ТОГДА уатРабочееВремяСотрудниковОбороты.Регистратор.ТранспортноеСредство
		|			ИНАЧЕ уатРабочееВремяСотрудниковОбороты.Регистратор.ТС
		|		КОНЕЦ, ЗНАЧЕНИЕ(Справочник.уатТС.ПустаяСсылка)) КАК ТранспортноеСредство,
		|	уатРабочееВремяСотрудниковОбороты.Регистратор КАК Регистратор
		|ИЗ
		|	втДанныеСотрудников КАК втДанныеСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.уатРабочееВремяСотрудников.Обороты(
		|				,
		|				,
		|				Регистратор,
		|				(Сотрудник, Организация) В
		|					(ВЫБРАТЬ
		|						втДанныеСотрудников.Сотрудник КАК Сотрудник,
		|						втДанныеСотрудников.Организация КАК Организация
		|					ИЗ
		|						втДанныеСотрудников КАК втДанныеСотрудников)) КАК уатРабочееВремяСотрудниковОбороты
		|		ПО втДанныеСотрудников.Сотрудник = уатРабочееВремяСотрудниковОбороты.Сотрудник
		|			И втДанныеСотрудников.Организация = уатРабочееВремяСотрудниковОбороты.Организация
		|			И втДанныеСотрудников.Период = уатРабочееВремяСотрудниковОбороты.ДатаРаботы
		|
		|СГРУППИРОВАТЬ ПО
		|	втДанныеСотрудников.Период,
		|	втДанныеСотрудников.Сотрудник,
		|	втДанныеСотрудников.Организация,
		|	втДанныеСотрудников.ГрафикРаботы,
		|	уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени,
		|	ВЫБОР
		|		КОГДА уатРабочееВремяСотрудниковОбороты.ВидИспользованияРабочегоВремени.ИспользоватьКакРабочееВремя = ИСТИНА
		|			ТОГДА ""Рабочее""
		|		ИНАЧЕ ""НеРабочее""
		|	КОНЕЦ,
		|	ЕСТЬNULL(ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(уатРабочееВремяСотрудниковОбороты.Регистратор) = ТИП(Документ.уатПутевойЛист)
		|				ТОГДА уатРабочееВремяСотрудниковОбороты.Регистратор.ТранспортноеСредство
		|			ИНАЧЕ уатРабочееВремяСотрудниковОбороты.Регистратор.ТС
		|		КОНЕЦ, ЗНАЧЕНИЕ(Справочник.уатТС.ПустаяСсылка)),
		|	уатРабочееВремяСотрудниковОбороты.Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втВремяПоГрафику.ДатаГрафика,
		|	втВремяПоГрафику.Сотрудник,
		|	втВремяПоГрафику.Организация,
		|	втВремяПоГрафику.ГрафикРаботы,
		|	втВремяПоГрафику.ВидВремени,
		|	втВремяПоГрафику.РабочееВремя,
		|	втВремяПоГрафику.Время,
		|	втВремяПоГрафику.ВремяНачала,
		|	втВремяПоГрафику.ВремяОкончания,
		|	втВремяПоГрафику.ДатаПриема,
		|	втВремяПоГрафику.ДатаУвольнения,
		|	NULL,
		|	втВремяПоГрафику.Регистратор
		|ИЗ
		|	втВремяПоГрафику КАК втВремяПоГрафику
		|ГДЕ
		|	втВремяПоГрафику.Сотрудник <> ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
		|	И втВремяПоГрафику.ГрафикРаботы <> ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка)";
		тблРез = Запрос.Выполнить().Выгрузить();
		
		тблРез.Свернуть("ДатаГрафика, Сотрудник, Организация, ГрафикРаботы, ВидВремени, РабочееВремя, ВремяНачала, ВремяОкончания, ДатаПриема, ДатаУвольнения, ТранспортноеСредство, Регистратор", "Время");

		СвернутьПоИнтерваламГрафиков(тблРез);
		
	КонецЕсли;
	
	Возврат тблРез;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СвернутьПоИнтерваламГрафиков(тблРез)
	тблРезПромежуточная = тблРез.Скопировать();
	тблРезПромежуточная.Очистить();
	тблРезПромежуточная.Колонки.Добавить("Интервалы", Новый ОписаниеТипов("Массив"));
	
	// 1) Переносим без изменения строки не по графикам - либо факт рабочего времени, либо не по графику
	// - в этих строках точно нет разбиения по интервала, одна строка одна дата
	мсвСтрокиУдалить = Новый Массив;
	Для Каждого ТекСтрока Из тблРез Цикл
		Если ТекСтрока.РабочееВремя <> "ПоГрафику" Тогда
			НоваяСтрока = тблРезПромежуточная.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			мсвСтрокиУдалить.Добавить(ТекСтрока);
			
			// 2) Из Явок удаляем Ночные, поскольку в регистре РабочееВремя в Явку включаются Ночные
			Если ТекСтрока.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.Явка
				ИЛИ ТекСтрока.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.ВыходныеДни
				ИЛИ ТекСтрока.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.Праздники Тогда
					
				струкПоискНочные = Новый Структура("ДатаГрафика, Сотрудник, Организация, ГрафикРаботы, ВидВремени, РабочееВремя, ВремяНачала, ВремяОкончания, ДатаПриема, ДатаУвольнения, ТранспортноеСредство, Регистратор");
				ЗаполнитьЗначенияСвойств(струкПоискНочные, ТекСтрока);
				струкПоискНочные.ВидВремени = Справочники.уатВидыИспользованияРабочегоВремени.РаботаНочныеЧасы;
				мсвСтрокНочные = тблРез.НайтиСтроки(струкПоискНочные);
				Для Каждого ТекСтрокаНочные Из мсвСтрокНочные Цикл
					НоваяСтрока.Время = НоваяСтрока.Время - ТекСтрокаНочные.Время;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Для Каждого ТекСтрокаУдалить Из мсвСтрокиУдалить Цикл
		тблРез.Удалить(ТекСтрокаУдалить);
	КонецЦикла;
		
	тблВремДляСортировки = Новый ТаблицаЗначений;
	тблВремДляСортировки.Колонки.Добавить("ВремяНачала", Новый ОписаниеТипов("Дата"));
	тблВремДляСортировки.Колонки.Добавить("ВремяОкончания", Новый ОписаниеТипов("Дата"));
	
	тблПоГрафикамСвернутая = тблРез.Скопировать();
	тблПоГрафикамСвернутая.Свернуть("ТранспортноеСредство, ДатаУвольнения, ДатаПриема, РабочееВремя, ВидВремени, ГрафикРаботы, Организация, Сотрудник, ДатаГрафика, Регистратор", "Время");
	Для Каждого ТекСтрокаСвернутая Из тблПоГрафикамСвернутая Цикл
		НоваяСтрока = тблРезПромежуточная.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаСвернутая);
		
		мсвСтрокИнтервалы = тблРез.НайтиСтроки(Новый Структура("ТранспортноеСредство, Сотрудник, ДатаГрафика",
			ТекСтрокаСвернутая.ТранспортноеСредство, ТекСтрокаСвернутая.Сотрудник, ТекСтрокаСвернутая.ДатаГрафика));
			
		Если мсвСтрокИнтервалы.Количество() = 1 Тогда
			НоваяСтрока.ВремяНачала    = мсвСтрокИнтервалы[0].ВремяНачала;
			НоваяСтрока.ВремяОкончания = мсвСтрокИнтервалы[0].ВремяОкончания;
		Иначе
			тблВремДляСортировки.Очистить();
			Для Каждого ТекИнтервал Из мсвСтрокИнтервалы Цикл
				НоваяСтрокаВрем = тблВремДляСортировки.Добавить();
				НоваяСтрокаВрем.ВремяНачала = ТекИнтервал.ВремяНачала;
				НоваяСтрокаВрем.ВремяОкончания = ТекИнтервал.ВремяОкончания;
			КонецЦикла;
			тблВремДляСортировки.Сортировать("ВремяНачала");
			Для Каждого ТекСтрокаВремя Из тблВремДляСортировки Цикл
				НоваяСтрока.Интервалы.Добавить(Новый Структура("ВремяНачала, ВремяОкончания",
				ТекСтрокаВремя.ВремяНачала, ТекСтрокаВремя.ВремяОкончания));
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	тблРез = тблРезПромежуточная;
КонецПроцедуры

#КонецОбласти

#КонецЕсли