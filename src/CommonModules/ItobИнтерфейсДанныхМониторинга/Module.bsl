#Область ПрограммныйИнтерфейс

#Область ДанныеМониторингаПодвижныхОбъектов

// Позволяет получить данные по маршрутам объектов мониторинга за определенный период времени в виде таблицы значений.
// Состав колонок возвращаемой таблицы см. в ItobОперативныйМониторинг.СоздатьТаблицуЗначенийМаршрутОбъектаМониторинга, 
// так же в таблице добавляется колонка "ОбъектМониторинга". Данные берутся не из ИБ, а из IMCS через http запрос.
//	
// Параметры:
//  ОбъектыМониторинга	 - Массив из ОпределяемыйТип.ItobОбъектМониторинга	 - Массив ссылок на объекты мониторинга.
//  ПериодС				 - Дата	 - Период начала маршрута.
//  ПериодПо			 - Дата	 - Период окончания маршрута.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Маршруты объектов мониторинга 
//
Функция МаршрутыОбъектовПоДаннымМониторинга(ОбъектыМониторинга, ПериодС, ПериодПо) Экспорт
	
	ДанныеОбъектовМониторинга = Неопределено;
	Для каждого Объект Из ОбъектыМониторинга Цикл
		Если ДанныеОбъектовМониторинга = Неопределено Тогда
			ДанныеОбъектовМониторинга = МаршрутОбъектаПоДаннымМониторинга(Объект, ПериодС, ПериодПо);
		ИначеЕсли ТипЗнч(ДанныеОбъектовМониторинга) = Тип("ТаблицаЗначений") Тогда  
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(МаршрутОбъектаПоДаннымМониторинга(Объект, ПериодС, ПериодПо), 
														  ДанныеОбъектовМониторинга);
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат ДанныеОбъектовМониторинга;
	
КонецФункции

// Позволяет получить данные по маршруту объекта мониторинга за определенный период времени в виде таблицы значений.
// Состав колонок возвращаемой таблицы см. в ItobОперативныйМониторинг.СоздатьТаблицуЗначенийМаршрутОбъектаМониторинга, 
// так же в таблице добавляется колонка "ОбъектМониторинга". Данные берутся не из ИБ, а из IMCS через http запрос.
//	
// Параметры:
//  ОбъектМониторинга	 - ОпределяемыйТип.ItobОбъектМониторинга - ссылка на объект мониторинга.
//  ПериодС				 - Дата	 - Период начала маршрута.
//  ПериодПо			 - Дата	 - Период окончания маршрута.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Маршрут объекта мониторинга 
//
Функция МаршрутОбъектаПоДаннымМониторинга(ОбъектМониторинга, ПериодС, ПериодПо) Экспорт
	
	ДанныеОбъектаМониторинга = ItobОперативныйМониторинг.СформироватьМаршрутОбъектаМониторинга(ОбъектМониторинга, ПериодС, ПериодПо);

	Если ТипЗнч(ДанныеОбъектаМониторинга) = Тип("ТаблицаЗначений") Тогда
		ДанныеОбъектаМониторинга.Колонки.Добавить("ОбъектМониторинга");
		ДанныеОбъектаМониторинга.ЗаполнитьЗначения(ОбъектМониторинга, "ОбъектМониторинга");
	КонецЕсли; 
	
	Возврат ДанныеОбъектаМониторинга
	
КонецФункции

// Актуальные данные терминалов, привязанных к объектам мониторинга на текущую дату сеанса (данные будут получены из ИБ)
// 
// Параметры:
//  ОбъектыМониторинга	 - Массив из ОпределяемыйТип.ItobОбъектМониторинга	 - Массив ссылок на объекты мониторинга.
// 
// Возвращаемое значение:
//  ТаблицаЗначений
//
Функция АктуальныеДанныеТерминаловОбъектовМониторинга (ОбъектыМониторинга) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СдвигВремени", ItobОперативныйМониторинг.ПолучитьПараметрыСдвигаВремени().СдвигВремени);
	Запрос.УстановитьПараметр("ОбъектыМониторинга", ОбъектыМониторинга);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ItobАктуальностьДанныхТерминалов.Терминал КАК Терминал,
	|	ItobАктуальностьДанныхТерминалов.ДатаВремя КАК ПериодUTC0,
	|	ДОБАВИТЬКДАТЕ(ItobАктуальностьДанныхТерминалов.ДатаВремя, СЕКУНДА, &СдвигВремени) КАК Период,
	|	ItobАктуальностьДанныхТерминалов.Широта КАК Широта,
	|	ItobАктуальностьДанныхТерминалов.Долгота КАК Долгота,
	|	ItobАктуальностьДанныхТерминалов.Скорость КАК Скорость,
	|	ItobАктуальностьДанныхТерминалов.Направление КАК Направление,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки0 КАК ВидГруппировки0,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки1 КАК ВидГруппировки1,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки2 КАК ВидГруппировки2,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки3 КАК ВидГруппировки3,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки4 КАК ВидГруппировки4,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки5 КАК ВидГруппировки5,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки6 КАК ВидГруппировки6,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки7 КАК ВидГруппировки7,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки8 КАК ВидГруппировки8,
	|	ItobАктуальностьДанныхТерминалов.ВидГруппировки9 КАК ВидГруппировки9,
	|	ItobАктуальностьДанныхТерминалов.ДанныеДатчиков КАК ДанныеДатчиков,
	|	ItobАктуальностьДанныхТерминалов.КрайниеТочки КАК КрайниеТочки,
	|	ItobАктуальностьДанныхТерминалов.ПодходящийВариантДинамическогоОформления КАК ПодходящийВариантДинамическогоОформления,
	|	ItobПривязкиТрекеровСрезПоследних.Объект КАК Объект,
	|	ItobАктуальностьДанныхТерминалов.ПодходящийВариантДинамическогоОформленияПриЗадержкеДанных КАК ПодходящийВариантДинамическогоОформленияПриЗадержкеДанных
	|ИЗ
	|	РегистрСведений.ItobПривязкиТрекеров.СрезПоследних(, Объект В (&ОбъектыМониторинга)) КАК ItobПривязкиТрекеровСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobАктуальностьДанныхТерминалов КАК ItobАктуальностьДанныхТерминалов
	|		ПО ItobПривязкиТрекеровСрезПоследних.Терминал = ItobАктуальностьДанныхТерминалов.Терминал";

	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Актуальные данные терминала, привязанного к объекту мониторинга на текущую дату сеанса (данные будут получены из ИБ)
// 
// Параметры:
//  ОбъектМониторинга -  ОпределяемыйТип.ItobОбъектМониторинга	 - ссылка на объект мониторинга.
//
// Возвращаемое значение:
//  ТаблицаЗначений
//
Функция АктуальныеДанныеТерминалаОбъектаМониторинга(ОбъектМониторинга) Экспорт
		
	ОбъектыМониторинга = Новый Массив;
	ОбъектыМониторинга.Добавить(ОбъектМониторинга);

	Возврат АктуальныеДанныеТерминаловОбъектовМониторинга(ОбъектыМониторинга);
	
КонецФункции

// Сводные данные о движении объекта мониторинга
//
// Параметры:
//  ОбъектМониторинга	 - СправочникСсылка
//  ПериодНачало		 - Дата
//  ПериодОкончание		 - Дата
//  ТекстОшибки			 - Строка
//
// Возвращаемое значение:
//  Структура - Данные по ТС включающие в себя:
//		*ПробегGPS - Число
//		*ПробегCAN - Число
//		*СпидометрВыездаCAN - Число
//		*СпидометрВозвращенияCAN - Число
//		*ВремяРаботыДвигателя - Число
//		*ВремяВДвиженииСВклДВС - Число
//		*ВремяВПростоеСВклДВС - Число
//
Функция СводныеДанныеОДвиженииОбъектаМониторинга(ОбъектМониторинга, ПериодНачало, ПериодОкончание, ТекстОшибки = "") Экспорт
	
	ПолучатьДанныеТоплива = Ложь;
	Параметры = ПараметрыПолученияДанныхОбъектаМониторинга(ОбъектМониторинга, ПериодНачало, ПериодОкончание, ПолучатьДанныеТоплива); 
		
	СводныеДанные = ItobЗаполнениеПоДаннымТрекеров.ПолучитьДанныеПоТС_Локально(Параметры.Основные, ТекстОшибки, Параметры.ПараметрыЗаполнения);
	
	Возврат СводныеДанные;
	
КонецФункции

// Сводные данные о движении и расходе топлива объекта мониторинга
//
// Параметры:
//  ОбъектМониторинга	 - СправочникСсылка
//  ПериодНачало		 - Дата
//  ПериодОкончание		 - Дата
//  ТекстОшибки			 - Строка
//
// Возвращаемое значение:
//  Структура - Данные по ТС включающие в себя:
//		*ПробегGPS - Число
//		*ПробегCAN - Число
//		*СпидометрВыездаCAN - Число
//		*СпидометрВозвращенияCAN - Число
//		*ВремяРаботыДвигателя - Число
//		*УровеньТопливаНачало - Число
//		*УровеньТопливаКонец - Число
//		*РасходТоплива - Число
//		*ОбъемЗаправок - Число
//		*ВремяВДвиженииСВклДВС - Число
//		*ВремяВПростоеСВклДВС - Число
//
Функция СводныеДанныеОДвиженииИРасходеТопливаОбъектаМониторинга(ОбъектМониторинга, ПериодНачало, ПериодОкончание, ТекстОшибки = "") Экспорт
	
	ПолучатьДанныеТоплива = Истина;
	Параметры = ПараметрыПолученияДанныхОбъектаМониторинга(ОбъектМониторинга, ПериодНачало, ПериодОкончание, ПолучатьДанныеТоплива); 
	
	СводныеДанные = ItobЗаполнениеПоДаннымТрекеров.ПолучитьДанныеПоТС_Локально(Параметры.Основные, ТекстОшибки, Параметры.ПараметрыЗаполнения);
	
	Возврат СводныеДанные;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыПолученияДанныхОбъектаМониторинга(ОбъектМониторинга, ПериодНачало, ПериодОкончание, ЗаполнятьУровеньБака)
	
	ОсновныеПараметры = Новый Структура;
	ОсновныеПараметры.Вставить("ТранспортноеСредство", ОбъектМониторинга);
	ОсновныеПараметры.Вставить("ДатаВыезда", ПериодНачало);
	ОсновныеПараметры.Вставить("ДатаВозвращения", ПериодОкончание);

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ЗаполнятьОдометрПоПробегуGPS", Истина);
	ПараметрыЗаполнения.Вставить("ЗаполнятьУровеньБака", ЗаполнятьУровеньБака);
	
	
	Возврат Новый Структура("Основные, ПараметрыЗаполнения", ОсновныеПараметры, ПараметрыЗаполнения);
	
КонецФункции
 
#КонецОбласти 

#КонецОбласти