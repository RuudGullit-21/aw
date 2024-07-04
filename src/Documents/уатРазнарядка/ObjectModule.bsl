
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатРазнарядка.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение.ОтразитьСостояниеТС(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатРазнарядка.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.уатРазнарядка.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	// проверка ТС на признак автотранспорта
	Для Каждого ТекСтрока Из Разнарядка Цикл
		Если НЕ ТекСтрока.ТС.ВидМоделиТС = Перечисления.уатВидыМоделейТС.Автотранспорт Тогда
			ТекстНСТР = НСтр("en='At line №%1 vehicle is not transport (equipment selected)!';ru='В строке №%1 ТС не является автотранспортом (выбрано оборудование)!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ТекСтрока.НомерСтроки);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	// проверка на пересечения занятости (состояния) ТС по времени
	Для Каждого ТекСтрока Из Разнарядка Цикл
		Для Каждого ТекСтрокаВлож Из Разнарядка Цикл
			Если Разнарядка.Индекс(ТекСтрокаВлож) <= Разнарядка.Индекс(ТекСтрока) ИЛИ ТекСтрока.ТС <> ТекСтрокаВлож.ТС Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТекСтрока.ДатаВыезда < ТекСтрокаВлож.ДатаВозвращения И ТекСтрока.ДатаВозвращения > ТекСтрокаВлож.ДатаВыезда Тогда
				ТекстНСТР = НСтр("en='In lines №%1 and №%2 is detected the intersection of periods of employment (vehicle state) of the same vehicle!';ru='В строках №%1 и №%2 обнаружено пересечение периодов занятости (состояние ТС) одного и того же ТС!'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ТекСтрока.НомерСтроки, ТекСтрокаВлож.НомерСтроки);
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СекундИзменилась = НачалоДня(ТекущаяДата()) - НачалоДня(ОбъектКопирования.Дата);
	Для Каждого ТекСтрока Из Разнарядка Цикл
		ТекСтрока.ДатаВозвращения = ТекСтрока.ДатаВозвращения + СекундИзменилась;
		ТекСтрока.ДатаВыезда      = ТекСтрока.ДатаВыезда + СекундИзменилась;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	МассивТС = Новый Массив();
	Для Каждого ТекСтрока Из Разнарядка Цикл 
		Если МассивТС.Найти(ТекСтрока.ТС) = Неопределено Тогда 
			МассивТС.Добавить(ТекСтрока.ТС);
		КонецЕсли;
	КонецЦикла;
	
	СписокТС = "";
	Для Каждого ТекТС Из МассивТС Цикл 
		СписокТС = СписокТС + ?(СписокТС = "", "", ", ") + ТекТС.Наименование;
	КонецЦикла;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура перезаполняет таблицу Разнарядки
Процедура ЗаполнитьТаблицы() Экспорт
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(Организация) Тогда
		ТекстНСТР = НСтр("en='Not specified company!';ru='Не указана организация!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицыФрагмент();
КонецПроцедуры

Процедура ЗаполнитьТаблицыФрагмент()
    
    Перем Запрос, НоваяСтрока, СоставТС, СтруктураЭкипаж, тблРазнарядка, ТекСтрока, тСтрока, тСч;
    
    Разнарядка.Очистить();
    
    Запрос = Новый Запрос;
    Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
    |	уатТС.Модель,
    |	уатТС.ГаражныйНомер КАК ГарНомер,
    |	уатТС.ГосударственныйНомер КАК ГосНомер,
    |	уатТС.Гараж,
    |	уатТС.Ссылка КАК ТС,
    |	уатМестонахождениеТССрезПоследних.Организация КАК Организация,
    |	уатМестонахождениеТССрезПоследних.Колонна КАК Колонна,
    |	уатТС.ОсновнойРежимРаботы КАК РежимРаботыТС
    |ИЗ
    |	Справочник.уатТС КАК уатТС
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаНач, ) 
    |			КАК уатМестонахождениеТССрезПоследних
    |		ПО уатТС.Ссылка = уатМестонахождениеТССрезПоследних.ТС
    |ГДЕ
    |	уатМестонахождениеТССрезПоследних.Организация = &Организация
    |	И уатТС.Модель.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)
    |	И (уатТС.ТипТС = &ПустойТипТС
    |			ИЛИ (НЕ уатТС.ТипТС.ВидТС В (&СписокПрицепов)))
    |	И (уатТС.ДатаВыбытия = &ПустаяДата
    |			ИЛИ уатТС.ДатаВыбытия > &ДатаДокумента)";
    
    Если ЗначениеЗаполнено(Колонна) Тогда
        Запрос.Текст = Запрос.Текст + "
        |	И уатМестонахождениеТССрезПоследних.Колонна В Иерархии (&Колонна)";
        Запрос.УстановитьПараметр("Колонна", Колонна);
    КонецЕсли;				   
    
    Запрос.УстановитьПараметр("ПустойТипТС", Справочники.уатТипыТС.ПустаяСсылка());
    Запрос.УстановитьПараметр("СписокПрицепов", уатОбщегоНазначения.уатСписокВидовТСПрицепов());
    Запрос.УстановитьПараметр("Организация", Организация);
    Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Дата));
    Запрос.УстановитьПараметр("ДатаКон", КонецДня(Дата));
    Запрос.УстановитьПараметр("ДатаДокумента", Дата);
    Запрос.УстановитьПараметр("ПустаяДата", '00010101');
    
    тблРазнарядка = Разнарядка.Выгрузить();
    тблРазнарядка.Колонки.Добавить("ГарНомер");
    тблРазнарядка.Колонки.Добавить("ГосНомер");
    Для Каждого ТекСтрока Из Запрос.Выполнить().Выгрузить() Цикл
        НоваяСтрока = тблРазнарядка.Добавить();
        ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
    КонецЦикла;
    
    Для каждого ТекСтрока из тблРазнарядка Цикл
        // Заполняем прицепы по умолчанию
        тСч = 0;
        СоставТС = уатОбщегоНазначения.уатСоставТС(ТекСтрока.ТС);
        Для Каждого тСтрока из СоставТС Цикл
            тСч = тСч + 1;
            Если тСч = 1 Тогда 
                ТекСтрока.Прицеп1 = тСтрока.ТС;
            ИначеЕсли тСч = 2 Тогда
                ТекСтрока.Прицеп2 = тСтрока.ТС;
            Иначе	
                Прервать; 
            КонецЕсли;
        КонецЦикла;	
        
        Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ТекСтрока.РежимРаботыТС) Тогда
            #Если Клиент Тогда
                ТекСтрока.ДатаВыезда = НачалоДня(Дата) + (уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
                Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВремяВыездаПЛ) - '00010101');
                ТекСтрока.ДатаВозвращения = НачалоДня(Дата) + (уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
                Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВремяВозращенияПЛ) - '00010101');
            #КонецЕсли
        Иначе	
            ТекСтрока.ДатаВыезда = НачалоДня(Дата) + (ТекСтрока.РежимРаботыТС.НачалоРаботы - НачалоДня(
            ТекСтрока.РежимРаботыТС.НачалоРаботы));
            ТекСтрока.ДатаВозвращения = НачалоДня(Дата) + (ТекСтрока.РежимРаботыТС.КонецРаботы - НачалоДня(
            ТекСтрока.РежимРаботыТС.КонецРаботы));
        КонецЕсли;	
        Если ТекСтрока.ДатаВозвращения <= ТекСтрока.ДатаВыезда Тогда
            ТекСтрока.ДатаВозвращения = НачалоДня(Дата) + 86400 + (ТекСтрока.ДатаВозвращения - НачалоДня(
            ТекСтрока.ДатаВозвращения));
        КонецЕсли;	
        
        // заполняем водителей
		уатОбщегоНазначения.ЗаполнитьЭкипажТС(ТекСтрока.ТС, Организация, ТекСтрока.ДатаВыезда,
			ТекСтрока.Водитель, ТекСтрока.Водитель2, ТекСтрока.Кондуктор, ТекСтрока.Кондуктор2,
			Истина, ТекСтрока.ДатаВозвращения, Ложь);
    КонецЦикла;
    
    тблРазнарядка.Сортировать("ДатаВыезда");
    
    Разнарядка.Загрузить(тблРазнарядка);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
