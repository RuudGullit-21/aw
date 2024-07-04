#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаКон = НачалоМесяца(ТекущаяДата())-1;
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	КонецЕсли;
	
	Если Параметры.Свойство("Шина") Тогда
		Шина = Параметры.Шина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Шина) Тогда
		Сформировать(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	Если НЕ ЗначениеЗаполнено(Шина) Тогда
		Если НЕ ЗначениеЗаполнено(СерийныйНомер) Тогда
			ТекстНСТР = НСтр("en='Tire not specified!';ru='Не указана шина!'");
			ПоказатьПредупреждение(, ТекстНСТР, 10);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТабДок = СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьОтчет()
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ЗапросУстановкаСнятие = Новый Запрос();
	
	ЗапросУстановкаСнятие.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УстановленоНаТС.Период КАК ДатаУстановкиШиныНаТС,
	|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ДатаСнятияШиныСТС,
	|	УстановленоНаТС.СерияНоменклатуры КАК Шины,
	|	УстановленоНаТС.ТС КАК ТС,
	|	УстановленоНаТС.ТС.Модель КАК МодельТС,
	|	УстановленоНаТС.ТС.ГаражныйНомер КАК ИнвНомерТС,
	|	УстановленоНаТС.ТС.ГосударственныйНомер КАК ГосударственныйНомер,
	|	УстановленоНаТС.МестоУстановки КАК МестоУстановки,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(200)) КАК РегистраторПричинаОбращения,
	|	УстановленоНаТС.СерияНоменклатуры.Модель КАК СерияНоменклатурыМодель,
	|	УстановленоНаТС.СерияНоменклатуры.Наименование КАК СерияНоменклатурыНаименование
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС КАК УстановленоНаТС
	|ГДЕ
	|	УстановленоНаТС.СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)";
	
	Если ЗначениеЗаполнено(Шина) Тогда
		ЗапросУстановкаСнятие.УстановитьПараметр("Шина", Шина);
		ЗапросУстановкаСнятие.Текст = ЗапросУстановкаСнятие.Текст + "
		| И УстановленоНаТС.СерияНоменклатуры = &Шина";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		ЗапросУстановкаСнятие.УстановитьПараметр("СерийныйНомер", СерийныйНомер);
		ЗапросУстановкаСнятие.Текст = ЗапросУстановкаСнятие.Текст + "
		| И УстановленоНаТС.СерияНоменклатуры.СерийныйНомер = &СерийныйНомер";
	КонецЕсли;

	ЗапросУстановкаСнятие.Текст = ЗапросУстановкаСнятие.Текст + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СнятоСТС.Период КАК ДатаСнятияШиныСТС,
	|	СнятоСТС.СерияНоменклатуры КАК Шины,
	|	СнятоСТС.ТС КАК ТС,
	|	СнятоСТС.МестоУстановки КАК МестоУстановки,
	|	СнятоСТС.Регистратор.ПричинаОбращения КАК РегистраторПричинаОбращения
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС КАК СнятоСТС
	|ГДЕ
	|	СнятоСТС.СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)";
	
	Если ЗначениеЗаполнено(Шина) Тогда
		ЗапросУстановкаСнятие.Текст = ЗапросУстановкаСнятие.Текст + "
		| И СнятоСТС.СерияНоменклатуры = &Шина";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		ЗапросУстановкаСнятие.Текст = ЗапросУстановкаСнятие.Текст + "
		| И СнятоСТС.СерияНоменклатуры.СерийныйНомер = &СерийныйНомер";
	КонецЕсли;
	
	мсвРезультаты = ЗапросУстановкаСнятие.ВыполнитьПакет();
		
	ТабУстановки = мсвРезультаты[0].Выгрузить();
	ТабСнятия    = мсвРезультаты[1].Выгрузить();
	
	ФлагОбщаяМодель			 = Истина;
	ФлагОбщееНаименование	 = Истина;
	НомерСторки				 = 1;
	МодельШины				 = Шина.Модель;
	ОбозначениеШины			 = "";
	мШина					 = Новый Массив();
	Для Каждого ТекСтрока Из ТабУстановки Цикл
		
		ФлагОбщаяМодель			 = ТекСтрока.СерияНоменклатурыМодель = МодельШины ИЛИ НомерСторки = 1;
		ФлагОбщееНаименование	 = ТекСтрока.СерияНоменклатурыНаименование = ОбозначениеШины ИЛИ НомерСторки = 1;
		МодельШины				 = ТекСтрока.СерияНоменклатурыМодель;
		ОбозначениеШины			 = ТекСтрока.СерияНоменклатурыНаименование;
		мШина.Добавить(ТекСтрока.Шины);
		
		НайдСтроки = ТабСнятия.НайтиСтроки(Новый Структура("ТС,МестоУстановки",ТекСтрока.ТС,ТекСтрока.МестоУстановки));
		Если НайдСтроки.Количество() Тогда 
			Для Каждого СтрокаСнятия Из НайдСтроки Цикл 
				Если СтрокаСнятия.ДатаСнятияШиныСТС >= ТекСтрока.ДатаУстановкиШиныНаТС Тогда 
					ТекСтрока.ДатаСнятияШиныСТС = СтрокаСнятия.ДатаСнятияШиныСТС;
					ТекСтрока.РегистраторПричинаОбращения = СтрокаСнятия.РегистраторПричинаОбращения;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		НомерСторки = НомерСторки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблШин.ДатаУстановкиШиныНаТС КАК ДатаУстановкиШиныНаТС,
	|	ТаблШин.ДатаСнятияШиныСТС КАК ДатаСнятияШиныСТС,
	|	ТаблШин.Шины КАК Шины,
	|	ТаблШин.ТС КАК ТС,
	|	ТаблШин.МодельТС КАК МодельТС,
	|	ТаблШин.ИнвНомерТС КАК ИнвНомерТС,
	|	ТаблШин.ГосударственныйНомер КАК ГосударственныйНомер,
	|	ТаблШин.МестоУстановки КАК МестоУстановки,
	|	ТаблШин.РегистраторПричинаОбращения КАК РегистраторПричинаОбращения
	|ПОМЕСТИТЬ ВРТ
	|ИЗ
	|	&ТаблШин КАК ТаблШин
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ПробегЗаМесяц.ПробегОборот, 0) КАК ПробегЗаМесяц,
	|	ЕСТЬNULL(ОбщийПробег.ПробегОборот, 0) КАК ПробегОбщий,
	|	УстановленныеШины.РегистраторПричинаОбращения КАК РегистраторПричинаОбращения,
	|	УстановленныеШины.ТС КАК ТС,
	|	УстановленныеШины.МодельТС КАК МодельТС,
	|	УстановленныеШины.ДатаУстановкиШиныНаТС КАК ДатаУстановкиШиныНаТС,
	|	УстановленныеШины.ДатаСнятияШиныСТС КАК ДатаСнятияШиныСТС,
	|	УстановленныеШины.ИнвНомерТС КАК ИнвНомерТС,
	|	УстановленныеШины.ГосударственныйНомер КАК ГосударственныйНомер
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВРТ.ДатаУстановкиШиныНаТС КАК ДатаУстановкиШиныНаТС,
	|		ВРТ.Шины КАК Шины,
	|		ВРТ.ДатаСнятияШиныСТС КАК ДатаСнятияШиныСТС,
	|		ВРТ.ТС КАК ТС,
	|		ВРТ.МодельТС КАК МодельТС,
	|		ВРТ.ИнвНомерТС КАК ИнвНомерТС,
	|		ВРТ.ГосударственныйНомер КАК ГосударственныйНомер,
	|		ВРТ.РегистраторПричинаОбращения КАК РегистраторПричинаОбращения
	|	ИЗ
	|		ВРТ КАК ВРТ) КАК УстановленныеШины
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			уатИзносПробегШинОбороты.ТС КАК ТС,
	|			уатИзносПробегШинОбороты.СерияНоменклатуры КАК СерияНоменклатуры,
	|			уатИзносПробегШинОбороты.Организация КАК Организация,
	|			СУММА(уатИзносПробегШинОбороты.ПробегОборот) КАК ПробегОборот
	|		ИЗ
	|			РегистрНакопления.уатИзносПробегШин.Обороты(НАЧАЛОПЕРИОДА(&ДатаКон, МЕСЯЦ), &ДатаКон, Регистратор, ";
	Если ЗначениеЗаполнено(Шина) Тогда
		Запрос.Параметры.Вставить("Шина", Шина);
		Запрос.Текст = Запрос.Текст + "СерияНоменклатуры = &Шина";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		Запрос.Параметры.Вставить("СерийныйНомер", СерийныйНомер);
		Запрос.Текст = Запрос.Текст +
		?(ЗначениеЗаполнено(Шина), " И ", "") + "СерияНоменклатуры.СерийныйНомер = &СерийныйНомер";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +") КАК уатИзносПробегШинОбороты";
	
	Запрос.Текст = Запрос.Текст + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			уатИзносПробегШинОбороты.ТС,
	|			уатИзносПробегШинОбороты.Организация,
	|			уатИзносПробегШинОбороты.СерияНоменклатуры) КАК ПробегЗаМесяц
	|		ПО УстановленныеШины.Шины = ПробегЗаМесяц.СерияНоменклатуры
	|			И УстановленныеШины.ТС = ПробегЗаМесяц.ТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			уатИзносПробегШинОбороты.ТС КАК ТС,
	|			уатИзносПробегШинОбороты.СерияНоменклатуры КАК СерияНоменклатуры,
	|			уатИзносПробегШинОбороты.Организация КАК Организация,
	|			СУММА(уатИзносПробегШинОбороты.ПробегОборот) КАК ПробегОборот
	|		ИЗ
	|			РегистрНакопления.уатИзносПробегШин.Обороты(, &ДатаКон, Регистратор, ";
	
	Если ЗначениеЗаполнено(Шина) Тогда
		Запрос.Текст = Запрос.Текст + "СерияНоменклатуры = &Шина";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		Запрос.Текст = Запрос.Текст +
		?(ЗначениеЗаполнено(Шина), " И ", "") + "СерияНоменклатуры.СерийныйНомер = &СерийныйНомер";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +") КАК уатИзносПробегШинОбороты";
	
	Запрос.Текст = Запрос.Текст + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			уатИзносПробегШинОбороты.ТС,
	|			уатИзносПробегШинОбороты.Организация,
	|			уатИзносПробегШинОбороты.СерияНоменклатуры) КАК ОбщийПробег
	|		ПО УстановленныеШины.Шины = ОбщийПробег.СерияНоменклатуры
	|			И УстановленныеШины.ТС = ОбщийПробег.ТС";
	
	
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("Макет");
	
	Шапка = Макет.ПолучитьОбласть("Заголовок");

	Шапка.Параметры.НазваниеОрганизации	= уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Организация, ДатаКон),
		"ПолноеНаименование, ЮридическийАдрес, Телефоны");
	
	Шапка.Параметры.Шина				= Шина;
	Шапка.Параметры.МодельШины			= ?(ФлагОбщаяМодель, МодельШины, "");
	Если ЗначениеЗаполнено(СерийныйНомер) Тогда
		Шапка.Параметры.СерийныйномерШины	= СерийныйНомер;
	Иначе
		Шапка.Параметры.СерийныйномерШины	= Шина.СерийныйНомер;
	КонецЕсли;
	Шапка.Параметры.ОбозначениеШины		= ?(ФлагОбщееНаименование, ОбозначениеШины, "");
	ЗапроспоШине= новый запрос;
	ЗапросПоШине.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатМестонахождениеТССрезПоследних.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС.СрезПоследних(&Дата, ) КАК уатАгрегатыТССрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&Дата, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО уатАгрегатыТССрезПоследних.ТС = уатМестонахождениеТССрезПоследних.ТС
	|ГДЕ
	|	уатАгрегатыТССрезПоследних.СерияНоменклатуры В(&СерияНоменклатуры)
	|
	|УПОРЯДОЧИТЬ ПО
	|	уатМестонахождениеТССрезПоследних.Период УБЫВ";
	ЗапроспоШине.УстановитьПараметр("СерияНоменклатуры", ?(ФлагОбщаяМодель, мШина, Шина));
	ЗапроспоШине.УстановитьПараметр("Дата"             , ДатаКон);
	ВыборкаПоШине=ЗапроспоШине.Выполнить().Выбрать();
	Если ВыборкаПоШине.Следующий() Тогда
		Шапка.Параметры.НомерКолонны = ВыборкаПоШине.Подразделение;
	КонецЕсли;	
	
	// запрос по началу эксплуатации
	Если ЗначениеЗаполнено(Шина) ИЛИ ФлагОбщаяМодель Тогда
		ЗапросДатаПоступления = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатОстаткиАгрегатовОбороты.Период КАК Период
		|ИЗ
		|	РегистрНакопления.уатОстаткиАгрегатов.Обороты(, , Регистратор, СерияНоменклатуры В (&Шина)) КАК уатОстаткиАгрегатовОбороты
		|ГДЕ
		|	уатОстаткиАгрегатовОбороты.КоличествоПриход > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	уатАгрегатыТССрезПервых.Период
		|ИЗ
		|	РегистрСведений.уатАгрегатыТС.СрезПервых(, СерияНоменклатуры В (&Шина)) КАК уатАгрегатыТССрезПервых
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период");
		ЗапросДатаПоступления.Параметры.Вставить("Шина", мШина);
		ВыборкаДатаПоступления = ЗапросДатаПоступления.Выполнить().Выбрать();
		Если ВыборкаДатаПоступления.Следующий() Тогда
			Шапка.Параметры.ДатаПоступления	= ВыборкаДатаПоступления.Период;
		КонецЕсли;
		Шапка.Параметры.Изготовитель = МодельШины.Производитель;
	КонецЕсли;
	
	ДокументРезультат.Вывести(Шапка);
	
	Если ДатаКон <> '00010101000000' Тогда
		Запрос.Параметры.Вставить("ДатаКон", КонецМесяца(ДатаКон));
	Иначе
		Запрос.Параметры.Вставить("ДатаКон", КонецМесяца(ТекущаяДата()));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТаблШин", ТабУстановки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("ЗаголовокОтчета");
	
	ДокументРезультат.Вывести(ЗаголовокОтчета);
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Строка = Макет.ПолучитьОбласть("Строка");
	
	Пока Выборка.Следующий() Цикл
		Строка.Параметры.Заполнить(Выборка);
		Строка.Параметры.ПредставлениеТС = Выборка.ГосударственныйНомер + ", " + Выборка.МодельТС + ", " + Выборка.ИнвНомерТС;
		Строка.Параметры.ТС = Выборка.ТС;
		Строка.Параметры.ПредставлениеПериода = Строка(Формат(ДатаКон, "ДФ=MM.yyyy")) + "г.";
		Строка.Параметры.ЗаМесяц = Выборка.ПробегЗаМесяц/1000;
		Строка.Параметры.ПробегОбщий = Выборка.ПробегОбщий/1000;
		ДокументРезультат.Вывести(Строка);
	КонецЦикла;
	
	Подвал = Макет.ПолучитьОбласть("Подвал");
	ДокументРезультат.Вывести(Подвал);
	
	// Ориентация страницы
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ПолеСлева = 0;
	ДокументРезультат.ПолеСправа = 0;
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "Карточка работы шины";
	
	Возврат ДокументРезультат;
КонецФункции // СформироватьОтчет()

#КонецОбласти
