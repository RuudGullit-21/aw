#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
#Область СлужебныйПрограммныйИнтерфейс

Функция СформироватьТаблицуДокументов(ПараметрыДлительногоЗадания) Экспорт
	
	//ВалютаРеглУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	СКД       = ПараметрыДлительногоЗадания.СхемаКомпоновкиДанных;
	Настройки = ПараметрыДлительногоЗадания.НастройкиКомпоновкиДанных;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
	
	КомпоновщикМакета   = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки     = КомпоновщикМакета.Выполнить(СКД,
		КомпоновщикНастроек.Настройки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, Неопределено, Истина);
	ПроцессорВывода     = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	РезультатСОтборами  = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если РезультатСОтборами.Колонки.Найти("Ссылка") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	уатЗаполнитьСуммуДокумента(РезультатСОтборами);
	
	ИтоговаяТаблицаЗначений = Новый ТаблицаЗначений();
	ИтоговаяТаблицаЗначений.Колонки.Добавить("НомерПП");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("Дата");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("Документ");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("НомерДок");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("ДатаВходящегоДокумента");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("НомерВходящегоДокумента");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("СуммаДок");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("Валюта");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("Инфо");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("Комментарий");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("ДокументРасшифровка");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("Ссылка");
	ИтоговаяТаблицаЗначений.Колонки.Добавить("ДатаСортировка");
	
	НаличиеКомментария = РезультатСОтборами.Колонки.Найти("Комментарий")     <> Неопределено;
	НаличиеСуммы       = РезультатСОтборами.Колонки.Найти("СуммаДокумента")  <> Неопределено;
	НаличиеВалюты      = РезультатСОтборами.Колонки.Найти("ВалютаДокумента") <> Неопределено;
	НаличиеИнформации  = РезультатСОтборами.Колонки.Найти("Информация")      <> Неопределено;
	НаличиеВхДаты      = РезультатСОтборами.Колонки.Найти("ДатаВходящегоДокумента")  <> Неопределено;
	НаличиеВхНомера    = РезультатСОтборами.Колонки.Найти("НомерВходящегоДокумента") <> Неопределено;
	
	ПроверятьТаблицуТовары = Ложь;
	ПроверятьТаблицуУслуги = Ложь;
	Если ПараметрыДлительногоЗадания.ЕстьОтборПоПервичнымДокументам Тогда
		Если ПараметрыДлительногоЗадания.ТоварыУслуги = 1 Тогда
			ТаблицыСТоварами = ВернутьНазванияТаблиц("ЕстьТовары", РезультатСОтборами.Колонки);
			ПроверятьТаблицуТовары = ТаблицыСТоварами.Количество() > 0;
		ИначеЕсли ПараметрыДлительногоЗадания.ТоварыУслуги = 2 Тогда
			ТаблицыСУслугами = ВернутьНазванияТаблиц("ЕстьУслуги", РезультатСОтборами.Колонки);
			ПроверятьТаблицуУслуги = ТаблицыСУслугами.Количество() > 0;
		КонецЕсли;
	КонецЕсли;
	
	ТипСсылки          = Неопределено;
	МетаданныеСсылки   = Неопределено;
	Для каждого Строка Из РезультатСОтборами Цикл
		Ссылка = Строка.Ссылка;
		
		Если ТипЗнч(Ссылка) <> ТипСсылки Тогда
			ТипСсылки        = ТипЗнч(Ссылка);
			МетаданныеСсылки = Ссылка.Метаданные();
		КонецЕсли;
		
		ИнформацияДляРеестра = Новый Структура;
		
		Если ПроверятьТаблицуТовары Тогда
			ЕстьТовары = Ложь;
			Для каждого Колонка Из ТаблицыСТоварами Цикл
				ЕстьТовары = ЕстьТовары ИЛИ Строка[Колонка] <> NULL;
			КонецЦикла;
			
			Если НЕ ЕстьТовары Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ПроверятьТаблицуУслуги Тогда
			ЕстьУслуги = Ложь;
			Для каждого Колонка Из ТаблицыСУслугами Цикл
				ЕстьУслуги = ЕстьУслуги ИЛИ Строка[Колонка] <> NULL;
			КонецЦикла;
			
			Если НЕ ЕстьУслуги Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ИнформацияДляРеестра.Вставить("Документ",            МетаданныеСсылки.Синоним);
		ИнформацияДляРеестра.Вставить("ДокументРасшифровка", Ссылка);
		ИнформацияДляРеестра.Вставить("ДатаСортировка",      Строка.Дата);
		
		Если НЕ ИнформацияДляРеестра.Свойство("Дата") Тогда
			ИнформацияДляРеестра.Вставить("Дата", Формат(Строка.Дата, "ДЛФ=Д"));
		КонецЕсли;
		
		Если НЕ ИнформацияДляРеестра.Свойство("НомерДок") Тогда	
			ПечатьПрефиксовВключена = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ИнформацияДляРеестра.ДокументРасшифровка.Организация, ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВыводитьПрефиксПриПечати"));
			Если ПечатьПрефиксовВключена Тогда
				мНомерНаПечать = Строка.Номер;
			Иначе
				мНомерНаПечать = уатОбщегоНазначенияКлиентСервер.НомерДокументаНаПечать(Строка.Номер, Истина, Истина);
			КонецЕсли;
			ИнформацияДляРеестра.Вставить("НомерДок", мНомерНаПечать);
		КонецЕсли;
		
		Если НаличиеВхДаты И НЕ ИнформацияДляРеестра.Свойство("ДатаВходящегоДокумента") Тогда
			ИнформацияДляРеестра.Вставить("ДатаВходящегоДокумента", Формат(Строка.ДатаВходящегоДокумента, "ДЛФ=Д"));
		КонецЕсли;
		
		Если НаличиеВхНомера И НЕ ИнформацияДляРеестра.Свойство("НомерВходящегоДокумента") Тогда
			ИнформацияДляРеестра.Вставить("НомерВходящегоДокумента", Строка.НомерВходящегоДокумента);
		КонецЕсли;
		
		Если НаличиеКомментария Тогда
			ИнформацияДляРеестра.Вставить("Комментарий", Строка.Комментарий);
		Иначе
			ИнформацияДляРеестра.Вставить("Комментарий", Ссылка.Комментарий);
		КонецЕсли;
		
		Если НЕ ИнформацияДляРеестра.Свойство("СуммаДок") И НаличиеСуммы Тогда
			ИнформацияДляРеестра.Вставить("СуммаДок", Строка.СуммаДокумента);
		КонецЕсли;
		
		Если НЕ ИнформацияДляРеестра.Свойство("Валюта") Тогда
			Если НаличиеВалюты Тогда
				ИнформацияДляРеестра.Вставить("Валюта", Строка.ВалютаДокумента);
			Иначе
				// Если настройка "Ведется учет в валюте и у.е." выключена, значит
				// используется только Валюта регламентированного учета
				ИнформацияДляРеестра.Вставить("Валюта", ВалютаРеглУчета);
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ИнформацияДляРеестра.Свойство("Инфо") И НаличиеИнформации Тогда
			ИнформацияДляРеестра.Вставить("Инфо", Строка.Информация);
		КонецЕсли;
		
		НоваяСтрока = ИтоговаяТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ИнформацияДляРеестра);
	КонецЦикла;
	
	ИтоговаяТаблицаЗначений.Сортировать("ДатаСортировка");
	
	НомерПП = 0;
	Для каждого Строка Из ИтоговаяТаблицаЗначений Цикл
		НомерПП = НомерПП + 1;
		Строка["НомерПП"] = НомерПП;
		Строка["Комментарий"] = Лев(Строка["Комментарий"], 100);
	КонецЦикла;
	
	Возврат ИтоговаяТаблицаЗначений;
	
КонецФункции

Процедура СформироватьТаблицуДокументовВФоне(ПараметрыДлительногоЗадания, АдресХранилища) Экспорт
	Результат = СформироватьТаблицуДокументов(ПараметрыДлительногоЗадания);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатОтчетОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "ФормаОтчета";
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ВернутьНазванияТаблиц(ЧтоИщем, КолонкиТаблицы)
	
	Массив = Новый Массив;
	
	Для каждого Колонка Из КолонкиТаблицы Цикл
		Если СтрНайти(Колонка.Имя, ЧтоИщем) > 0 Тогда
			Массив.Добавить(Колонка.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

Процедура уатЗаполнитьСуммуДокумента(ТаблицаДокументы)
	Если ТаблицаДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТаблицаДокументы.Колонки.Найти("СуммаДокумента") = Неопределено Тогда
		ТаблицаДокументы.Колонки.Добавить("СуммаДокумента");
	КонецЕсли;
	
	мсвДокументы = ТаблицаДокументы.ВыгрузитьКолонку("Ссылка");
	Если ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатСливГСМ") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатОстаткиГСМнаТС.Регистратор КАК Документ,
		|	СУММА(уатОстаткиГСМнаТС.Стоимость) КАК Сумма
		|ИЗ
		|	РегистрНакопления.уатОстаткиГСМнаТС КАК уатОстаткиГСМнаТС
		|ГДЕ
		|	уатОстаткиГСМнаТС.Регистратор В(&мсвДокументы)
		|	И уатОстаткиГСМнаТС.ВидДвижения = &ВидДвиженияРасход
		|СГРУППИРОВАТЬ ПО
		|	Регистратор");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		Запрос.УстановитьПараметр("ВидДвиженияРасход", ВидДвиженияНакопления.Расход);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатОтчетПоставщикаПЦ") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатОтчетПоставщикаПЦЗаправки.Ссылка КАК Документ,
		|	СУММА(уатОтчетПоставщикаПЦЗаправки.Сумма) КАК Сумма
		|ИЗ
		|	Документ.уатОтчетПоставщикаПЦ.Заправки КАК уатОтчетПоставщикаПЦЗаправки
		|ГДЕ
		|	уатОтчетПоставщикаПЦЗаправки.Ссылка В(&мсвДокументы)
		|СГРУППИРОВАТЬ ПО
		|	уатОтчетПоставщикаПЦЗаправки.Ссылка");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатВыдачаРасходныхМатериалов") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПартииТоваровНаСкладах.Регистратор КАК Документ,
		|	СУММА(уатПартииТоваровНаСкладах.Стоимость) КАК Сумма
		|ИЗ
		|	РегистрНакопления.уатПартииТоваровНаСкладах КАК уатПартииТоваровНаСкладах
		|ГДЕ
		|	уатПартииТоваровНаСкладах.Регистратор В(&мсвДокументы)
		|	И уатПартииТоваровНаСкладах.ВидДвижения = &ВидДвиженияРасход
		|СГРУППИРОВАТЬ ПО
		|	Регистратор");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		Запрос.УстановитьПараметр("ВидДвиженияРасход", ВидДвиженияНакопления.Расход);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатРемонтныйЛист") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатНоменклатураТС.Регистратор КАК Документ,
		|	СУММА(уатНоменклатураТС.Стоимость) КАК Сумма
		|ИЗ
		|	РегистрНакопления.уатНоменклатураТС КАК уатНоменклатураТС
		|ГДЕ
		|	уатНоменклатураТС.Регистратор В(&мсвДокументы)
		|СГРУППИРОВАТЬ ПО
		|	Регистратор");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
				
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатИнвентаризацияТоваров") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатИнвентаризацияТоваровТовары.Ссылка КАК Документ,
		|	СУММА(уатИнвентаризацияТоваровТовары.Сумма) КАК Сумма
		|ИЗ
		|	Документ.уатИнвентаризацияТоваров.Товары КАК уатИнвентаризацияТоваровТовары
		|ГДЕ
		|	уатИнвентаризацияТоваровТовары.Ссылка В(&мсвДокументы)
		|СГРУППИРОВАТЬ ПО
		|	уатИнвентаризацияТоваровТовары.Ссылка");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатПеремещениеТоваров") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПартииТоваровНаСкладах.Регистратор КАК Документ,
		|	СУММА(уатПартииТоваровНаСкладах.Стоимость) КАК Сумма
		|ИЗ
		|	РегистрНакопления.уатПартииТоваровНаСкладах КАК уатПартииТоваровНаСкладах
		|ГДЕ
		|	уатПартииТоваровНаСкладах.Регистратор В(&мсвДокументы)
		|	И уатПартииТоваровНаСкладах.ВидДвижения = &ВидДвиженияРасход
		|СГРУППИРОВАТЬ ПО
		|	Регистратор");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		Запрос.УстановитьПараметр("ВидДвиженияРасход", ВидДвиженияНакопления.Расход);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатСписаниеТоваров") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПартииТоваровНаСкладах.Регистратор КАК Документ,
		|	СУММА(уатПартииТоваровНаСкладах.Стоимость) КАК Сумма
		|ИЗ
		|	РегистрНакопления.уатПартииТоваровНаСкладах КАК уатПартииТоваровНаСкладах
		|ГДЕ
		|	уатПартииТоваровНаСкладах.Регистратор В(&мсвДокументы)
		|	И уатПартииТоваровНаСкладах.ВидДвижения = &ВидДвиженияРасход
		|СГРУППИРОВАТЬ ПО
		|	Регистратор");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		Запрос.УстановитьПараметр("ВидДвиженияРасход", ВидДвиженияНакопления.Расход);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатТТД") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатТТДСтоимость.Ссылка КАК Документ,
		|	СУММА(уатТТДСтоимость.Сумма) КАК Сумма
		|ИЗ
		|	Документ.уатТТД.Стоимость КАК уатТТДСтоимость
		|ГДЕ
		|	уатТТДСтоимость.Ссылка В(&мсвДокументы)
		|СГРУППИРОВАТЬ ПО
		|	уатТТДСтоимость.Ссылка");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		
	ИначеЕсли ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатМаршрутныйЛист") И уатРаботаСМетаданными.ЕстьТабЧастьДокумента("Доходы", "уатМаршрутныйЛист") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатМаршрутныйЛистДоходы.Ссылка КАК Документ,
		|	СУММА(уатМаршрутныйЛистДоходы.Сумма) КАК Сумма
		|ИЗ
		|	Документ.уатМаршрутныйЛист.Доходы КАК уатМаршрутныйЛистДоходы
		|ГДЕ
		|	уатМаршрутныйЛистДоходы.Ссылка В(&мсвДокументы)
		|СГРУППИРОВАТЬ ПО
		|	уатМаршрутныйЛистДоходы.Ссылка");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		
	ИначеЕсли уатРаботаСМетаданными.уатЕстьДокумент("уатАктКС3_стм") И ТипЗнч(ТаблицаДокументы[0].Ссылка) = Тип("ДокументСсылка.уатАктКС3_стм") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатАктКС3_стм.Ссылка КАК Документ,
		|	СУММА(уатАктКС3_стм.СуммаЗаОтчетныйПериод) КАК Сумма
		|ИЗ
		|	Документ.уатАктКС3_стм КАК уатАктКС3_стм
		|ГДЕ
		|	уатАктКС3_стм.Ссылка В(&мсвДокументы)
		|СГРУППИРОВАТЬ ПО
		|	уатАктКС3_стм.Ссылка");
		Запрос.УстановитьПараметр("мсвДокументы", мсвДокументы);
		
	Иначе
		Возврат;
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	тблСуммыДокументов = Новый ТаблицаЗначений;
	тблСуммыДокументов.Колонки.Добавить("Документ");
	тблСуммыДокументов.Колонки.Добавить("Сумма");
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = тблСуммыДокументов.Добавить();
		НоваяСтрока.Документ = Выборка.Документ;
		НоваяСтрока.Сумма = Выборка.Сумма;
	КонецЦикла;
	
	Для Каждого ТекСтрока Из ТаблицаДокументы Цикл
		ТекСтрокаСумма = тблСуммыДокументов.Найти(ТекСтрока.Ссылка, "Документ");
		Если ТекСтрокаСумма <> Неопределено Тогда
			ТекСтрока.СуммаДокумента = ТекСтрокаСумма.Сумма;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти


#КонецЕсли